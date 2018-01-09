# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless User.exists?('admin@ticketingsystem.com')
  User.create(email: 'admin@ticketingsystem.com', password: '123t!cketing@admin', admin: true)
end

unless User.exists?('viewer@ticketingsystem.com')
  User.create(email: 'viewer@ticketingsystem.com', password: '!@#password321')
end

['Sublime Text 3', 'Internet Explorer'].each do |name|
  unless Project.exists?(name: name)
    Project.create(name: name, description: "A Sample Project about #{name}")
  end
end

unless State.exists?
  State.create(name: "New", color: "#0066CC", default: true)
  State.create(name: "Open", color: "#008000")
  State.create(name: "Closed", color: "#990000")
  State.create(name: "Awesome", color: "#663399")
end
