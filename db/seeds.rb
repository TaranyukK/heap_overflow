user = User.find_or_initialize_by(email: 'test@test.com') do |usr|
  usr.password = '123456'
  usr.password_confirmation = '123456'
end
user.save!
