# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.create(name: 'Thomas McDonald', email: 'example@example.com')
u.authorizations << Authorization.new(email: 'example@example.com', provider: 'google', uid: 'lolnope')

u.questions << Question.new(title: 'What is QA?', body: 'I am unsure what this site is all about. Could somebody explain?')
u.save