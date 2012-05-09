unless User.where(:email => 'user@galdomedia.pl').exists?
  User.create!(:email => 'user@galdomedia.pl', :password => 'qwerty')
end

unless User.where(:email => 'admin@galdomedia.pl').exists?
  User.create!(:email => 'admin@galdomedia.pl', :password => 'qwerty')
end

SimpleForum::Category.create!(:name => 'Test category') unless SimpleForum::Category.exists?

SimpleForum::Forum.create!(:name => 'Test forum') { |f| f.category = SimpleForum::Category.first } unless SimpleForum::Forum.exists?
