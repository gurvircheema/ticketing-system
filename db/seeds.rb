# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless User.exists?('admin@ticketingsystem.com')
  User.create(email: 'admin@ticketingsystem.com', password: 'password', admin: true)
end

unless User.exists?('viewer@ticketingsystem.com')
  User.create(email: 'viewer@ticketingsystem.com', password: 'password')
end

['Sublime Text 3', 'Internet Explorer'].each do |name|
  unless Project.exists?(name: name)
    Project.create(name: name, description: "A Sample Project about #{name}")
  end
end
