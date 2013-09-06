# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tf2 = Game.find_or_create_by_name(:name => "Team Fortress 2",
	                              :description => "Free to play TF2",
	                              :logo_url => "http://media.steampowered.com/steamcommunity/public/images/apps/440/e3f595a92552da3d664ad00277fad2107345f743.jpg",
	                              :store_url => "http://store.steampowered.com/app/440/" )


l4d2 = Game.find_or_create_by_name(:name => "Left 4 Dead 2",
	                              :description => "Left 4 Dead 2",
	                              :logo_url => "http://media.steampowered.com/steamcommunity/public/images/apps/550/7d5a243f9500d2f8467312822f8af2a2928777ed.jpg",
	                              :store_url => "http://store.steampowered.com/app/550/" )
