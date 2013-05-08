User.seed(:id,
  { id: 1, name: 'Thomas McDonald', email: 'example@example.com', admin: true },
  { id: 2, name: 'John Doe', email: 'example2@example.com' }
)

Question.seed(:id,
  { id: 1, title: 'Is my QA instance running properly?', body: "I think I've installed QA. Is it all working correctly?", user_id: 2, last_active_at: DateTime.now, last_active_user_id: 2 }
)

Answer.seed(:id,
  { id: 1, body: 'If you can view this message, then most likely! Eventually we are looking at setting up a status page where you can view the status of various services QA depends on, but for now
    this is the best indication that your instance is working!', user_id: 2}
)