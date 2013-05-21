module QA
  module Import
    class StackExchange
      class Edit
        def initialize(edit)
          @result = {
            post_id: edit[0]['PostId'],
            comment: edit[0]['Comment'],
            user_id: edit[0]['UserId'],
            created_at: edit[0]['CreationDate']
          }

          edit.each do |attr|
            @result[:new_record] = true if [1, 2, 3].include? attr['PostHistoryTypeId'].to_i
            case attr['PostHistoryTypeId']
            when "1", "4", "7"
              @result[:title] = attr["Text"]
            when "2", "5", "8"
              @result[:body] = attr["Text"]
            when "3", "6", "9"
              # Handle what appears to be an edge case where a question has no tags... sigh.
              if attr["Text"]
                @result[:tag_list] = attr["Text"].split("><").each { |t| t.gsub!(/[<>]/, "") }.join(",")
              else
                @result[:tag_list] = "untagged"
              end
            end
          end
        end

        def [](sym)
          @result[sym]
        end

        def simple_hash
          @result.slice(:title, :body, :tag_list).merge(
            created_at: DateTime.parse(@result[:created_at]),
            last_active_at: DateTime.parse(@result[:created_at])
          )
        end
      end
    end
  end
end