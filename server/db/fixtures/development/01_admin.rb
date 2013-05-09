user = User.new(name: 'admin', email: 'admin@diors-cloud.com', password: 'password', password_confirmation: 'password')
user.admin = true
user.save
