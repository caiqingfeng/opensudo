# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Cai Qingfeng', :email => 'francois_cai@hotmail.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
puzzle = Puzzle.create! :name => "open sudo from android", :level => "4", :description => "open sudo from android", :cellstring => ",cell11:3,cell12:,cell13:,cell14:6,cell15:,cell16:,cell17:,cell18:8,cell19:,cell21:9,cell22:8,cell23:7,cell24:,cell25:1,cell26:4,cell27:,cell28:,cell29:,cell31:2,cell32:,cell33:,cell34:,cell35:3,cell36:,cell37:1,cell38:,cell39:,cell41:,cell42:7,cell43:,cell44:,cell45:,cell46:6,cell47:5,cell48:,cell49:,cell51:5,cell52:,cell53:,cell54:4,cell55:,cell56:9,cell57:,cell58:,cell59:6,cell61:,cell62:,cell63:9,cell64:3,cell65:,cell66:,cell67:,cell68:2,cell69:,cell71:,cell72:,cell73:8,cell74:,cell75:4,cell76:,cell77:,cell78:,cell79:5,cell81:,cell82:,cell83:,cell84:7,cell85:6,cell86:,cell87:9,cell88:1,cell89:8,cell91:,cell92:5,cell93:,cell94:,cell95:,cell96:3,cell97:,cell98:,cell99:2"
puts "new puzzle created!" << puzzle.name
