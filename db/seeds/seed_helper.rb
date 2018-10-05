module SeedHelper

  def self.generate_zeiten(seed)
    result = {}

    random = Random.new seed
    range_start = 9..13
    range_ende = 13..19

    frei_start = []
    frei_ende = []
    besch_start = []
    besch_ende = []
    frage_start = []
    frage_ende = []

    7.times{|i| frei_start.push random.rand(range_start)}
    puts "frei_start: #{frei_start}"
    7.times{|i| frei_ende.push random.rand(range_ende)}
    puts "frei_ende: #{frei_ende}"


    7.times do |i|
      st = frei_start[i]
      case st
      when 10..12
        besch_start.push 9
        besch_ende.push frei_start[i]
      when 9
        besch_start.push frei_ende[i]
        besch_ende.push random.rand(frei_ende[i]..19)
      end
    end

    puts "besch_start: #{besch_start}"
    puts "besch_ende: #{besch_ende}"

    7.times do |i|
      case besch_ende[i]
      when 10..12
        frage_start.push frei_ende[i]
        frage_ende.push 19
      when 13..19
        frage_start.push besch_ende[i]
        frage_ende.push 19
      end
    end

    puts "frage_start: #{frage_start}"
    puts "frage_ende: #{frage_ende}"

    result["frei_start"] = frei_start
    result["frei_ende"] = frei_ende
    result["besch_start"] = besch_start
    result["besch_ende"] = besch_ende
    result["frage_start"] = frage_start
    result["frage_ende"] = frage_ende
    result
  end

  def self.finde_mo_bis_so_datum (week_num)
    datums = []
    year = Time.now.year
    (1..7).each do |day|
      datums.push Date.commercial(year, week_num, day)
    end
    datums
  end

  def self.create_verfugbarkeiten(tage, zeiten, akt_user)

    tage.each_with_index do |akt_tag, index|
      puts "index: #{index}"
      verf_start = zeiten["frei_start"]
      verf_ende = zeiten["frei_ende"]
      besch_start = zeiten["besch_start"]
      puts "besch_start: #{besch_start}"
      besch_ende = zeiten["besch_ende"]
      frage_start = zeiten["frage_start"]
      frage_ende = zeiten["frage_ende"]

      verf1 = Verfugbarkeit.create(status: :verfügbar, user_id: akt_user.id, start: Time.mktime(akt_tag.year, akt_tag.month, akt_tag.day, verf_start[index]), ende: Time.mktime(akt_tag.year, akt_tag.month, akt_tag.day, verf_ende[index]))
      verf2 = Verfugbarkeit.create(status: :abwesend, user_id: akt_user.id, start: Time.mktime(akt_tag.year, akt_tag.month, akt_tag.day, besch_start[index]), ende: Time.mktime(akt_tag.year, akt_tag.month, akt_tag.day, besch_ende[index]))
      verf3 = Verfugbarkeit.create(status: :fragen, user_id: akt_user.id, start: Time.mktime(akt_tag.year, akt_tag.month, akt_tag.day, frage_start[index]), ende: Time.mktime(akt_tag.year, akt_tag.month, akt_tag.day, frage_ende[index]))
    end

  end

  puts "In my_module.rb"

end
