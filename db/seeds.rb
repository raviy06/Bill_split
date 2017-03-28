# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(:name => 'Amar', :email => '1@1.com', :password => 'amar123', :password_confirmation => 'amar123')
User.create!(:name => 'Akbar', :email => '2@2.com',:password => 'akbar123', :password_confirmation => 'akbar123')
User.create!(:name => 'Anthony', :email => '3@3.com',:password => 'anthony123', :password_confirmation => 'anthony123')