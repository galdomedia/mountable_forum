unless User.where(:email => 'test@test.com').exists?
  User.create!(:email => 'test@test.com', :password => 'qwerty')
end

SimpleForum::Category.create!(:name => 'Test category') unless SimpleForum::Category.exists?

SimpleForum::Forum.create!(:name => 'Test forum') { |f| f.category = SimpleForum::Category.first } unless SimpleForum::Forum.exists?
