user1 = User.new(name: 'roger.chen', email: 'roger.chen@dianping.com', password: 'password', password_confirmation: 'password')
user1.save

user2 = User.new(name: 'qa-intern03', email: 'qa-intern03@dianping.com', password: 'password', password_confirmation: 'password')
user2.save

project1 = Project.new(name: 'roger1', slug: 'roger1')
project1.owner = user1
project1.save

project2 = Project.new(name: 'roger2', slug: 'roger2')
project2.owner = user1
project2.save

project1.users << user2