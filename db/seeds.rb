# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require File.expand_path('../seeds/seed_helper', __FILE__)


User.create(typ: :Administrator, name: "admin", username: "admin", password_digest: BCrypt::Password.create('admin'))
paula = User.create(typ: :Mitarbeiter, name: "Paula", username: "paula", password_digest: BCrypt::Password.create('paula'))
sophia = User.create(typ: :Mitarbeiter, name: "Sophia", username: "sophia", password_digest: BCrypt::Password.create('sophia'))


seed = 115032730400174366788466674494640623225
seed2 = 115032730400174366788466674494640623355
seed3 = 115032730400174366788466674494640625454
seed4 = 115032730400174366788466674494640699883

woche_jetzt = Time.now.to_date.cweek

zeiten = SeedHelper.generate_zeiten(seed)
tage = SeedHelper.finde_mo_bis_so_datum(woche_jetzt)


puts "zeiten: #{zeiten}"
puts "tage: #{tage}"

SeedHelper.create_verfugbarkeiten(tage, zeiten, paula)

zeiten = SeedHelper.generate_zeiten(seed2)

SeedHelper.create_verfugbarkeiten(tage, zeiten, sophia)

tage = SeedHelper.finde_mo_bis_so_datum(woche_jetzt + 1)
zeiten = SeedHelper.generate_zeiten(seed3)

puts "zeiten: #{zeiten}"
puts "tage: #{tage}"
SeedHelper.create_verfugbarkeiten(tage, zeiten, paula)

zeiten = SeedHelper.generate_zeiten(seed4)
SeedHelper.create_verfugbarkeiten(tage, zeiten, sophia)

puts "zeiten: #{zeiten}"
puts "tage: #{tage}"
