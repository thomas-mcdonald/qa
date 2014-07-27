User.seed(:id,
  { id: 1, name: 'Thomas McDonald', email: 'example@example.com', admin: true },
  { id: 2, name: 'John Doe', email: 'example2@example.com' },
  { id: 3, name: 'Jane Doe', email: 'example3@example.com', moderator: true },
  { id: 4, name: 'Richard Roe', email: 'example4@example.com' }
)

Question.seed(:id,
  { id: 1, accepted_answer_id: 1, user_id: 2,
    title: 'Is my QA instance running properly?',
    body: "I think I've installed QA. Is it working correctly?",
    tag_list: 'faq',
    last_active_at: DateTime.now, last_active_user_id: 2 }
)

Answer.seed(:id,
  { id: 1, question_id: 1, user_id: 1,
    body: 'If you can view this message, then most likely! Eventually we are looking at setting up a status page where you can view the status of various services QA depends on, but for now
    this is the best indication that your instance is working.'}
)

Vote.seed(:id,
  { id: 1, user_id: 2, post_type: 'Answer', post_id: 1, vote_type: 'upvote' },
  { id: 2, user_id: 3, post_type: 'Answer', post_id: 1, vote_type: 'upvote' }
)

# Update the vote count on the seeded answers
Question.all.each { |q| q.update_vote_count! }
Answer.all.each { |a| a.update_vote_count! }
