require 'pp'

# what even.
# https://github.com/james2m/seedbank#defining-and-using-methods
class << self
  def create_question(q, user_ids)
    uid = q['user'] || user_ids.sample
    question = QuestionCreator.new(uid, {
      title: q['title'],
      body: q['body'],
      tag_list: q['tag_list']
    }).create
    make_score(question, q['score'], user_ids - [uid])
    question
  end
  
  def create_answer(question, a, user_ids)
    uid = a['user'] || user_ids.sample
    answer = AnswerCreator.new(question, User.find(uid), {
      body: a['body']
    }).create
    make_score(answer, a['score'], user_ids - [uid])
    question.accept_answer(answer) && question.save if a['accepted']
    answer
  end

  def make_score(post, score, user_ids)
    type = score > 0 ? :upvote : :downvote
    score.abs.times do
      v = VoteCreator.new(User.find(user_ids.sample), {
        post_id: post.id,
        post_type: post.class.to_s,
        vote_type: type
      }).create
    end    
  end
end

after 'development:users' do
  user_ids = User.where('admin = ?', false).pluck(:id)
  questions = YAML.load_file("#{Rails.root}/db/seeds/development/posts.yaml")['questions']
  questions.each do |q|
    question = create_question(q, user_ids)
    q['answers'].each do |a|
      answer = create_answer(question, a, user_ids)
    end
  end
end