# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admins = ['brendan.fosberry@gmail.com']

admins.each do |a|
  u = User.where({:email => a}).first
  u.update_attributes(:admin => true) if u
end
