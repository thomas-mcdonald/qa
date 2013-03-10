module QA
  module Import
    class StackExchange
      def initialize(dir)
        @dir = dir
        create_users
      end

      def create_users
        users_doc = Nokogiri::XML::Document.parse(File.read("#{@dir}/users.xml")).css('users row')
        users = []
        users_doc.each do |u|
          next if u["Id"].to_i < 0
          users << User.new(name: u["DisplayName"], email: FactoryGirl.generate(:email), id: u["Id"])
        end
        User.import users
      end
    end
  end
end