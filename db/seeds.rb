# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.where({email: 'mm@it.hr', name: 'Mirna', admin: true}).first_or_create!

# Location.where({title: 'MSU', description: 'na parkingu sa istocne strane', lat: 45.77876, lng: 15.98270}).first_or_create!
Location.where({title: 'Location 1', description: 'Location description'}).first_or_create!
Location.where({title: 'Location 2', description: 'Location description'}).first_or_create!

Group.where({title: 'Group 1'}).first_or_create!
Group.where({title: 'Group 2'}).first_or_create!
# Group.where({title: 'Other'}).first_or_create!