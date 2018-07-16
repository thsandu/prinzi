require 'test_helper'

class BuchungTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  end

  def teardown
  end


  def test_create_frei_Buchung
    ab_zeit = Time.mktime(2018, 03, 18, 10)
    bis_zeit = Time.mktime(2018, 03, 18, 12)
    buchung = Buchung.new
    buchung.befreie_zeitraum(ab_zeit, bis_zeit)

    start_here = buchung.start.in_time_zone('Europe/Bucharest')
    ende_here = buchung.ende.in_time_zone('Europe/Bucharest')


    assert_equal 10, start_here.hour
    assert_equal 00, start_here.min
    assert_equal 12, ende_here.hour
    assert_equal 00, ende_here.min
    assert_equal 'frei', buchung.status
  end

  def test_create_besetzt_Buchung
    buchung = Buchung.new
    ab_zeit = Time.mktime(2018, 03, 18, 11)
    bis_zeit = Time.mktime(2018, 03, 18, 13)
    buchung.besetze_zeitraum(ab_zeit, bis_zeit)

    start_here = buchung.start.in_time_zone('Europe/Bucharest')
    ende_here = buchung.ende.in_time_zone('Europe/Bucharest')

    assert_equal '11:00', start_here.strftime("%H:%M")
    assert_equal '13:00', ende_here.strftime("%H:%M")
    assert_equal 'besetzt', buchung.status
  end

  def test_empty_Verfugbarkeit
    verf = Verfugbarkeit.new
    verf.tag = Time.mktime(2018, 01, 01, 13)
    assert_equal '01.01', verf.tag.strftime("%d.%m")
  end

  def test_Verfugbarkeit_one_buchung_frei
    verf = Verfugbarkeit.new
    verf.tag = Time.mktime(2018, 03, 01)
    verf.save!
    verf.erzeuge_buchung_frei(Time.mktime(2018, 03, 18, 10, 30), Time.mktime(2018, 03, 18, 12, 30))

    assert_equal 1, verf.buchungs.size
    assert_equal '10:30 EET', verf.buchungs.first.start.strftime("%H:%M %Z")
    assert_equal '12:30 EET', verf.buchungs.first.ende.strftime("%H:%M %Z")
  end

  def test_Verfugbarkeit_two_buchung_frei
    verf = Verfugbarkeit.new
    verf.tag = Time.mktime(2018, 01, 01)
    verf.save!
    start1 = Time.mktime(2018, 01, 01, 10, 30)
    start2 = Time.mktime(2018, 01, 01, 12, 30)
    ende1 = Time.mktime(2018, 01, 01, 12, 29)
    ende2 = Time.mktime(2018, 01, 01, 14, 29)
    verf.erzeuge_buchung_frei(start1, ende1)
    verf.erzeuge_buchung_frei(start2, ende2)

    assert_equal 2, verf.buchungs.size
    assert_equal start1, verf.buchungs.first.start
    assert_equal start2, verf.buchungs[1].start
    assert_equal ende1, verf.buchungs.first.ende
    assert_equal ende2, verf.buchungs[1].ende

  end

  def test_buchung_moeglich_negative
    verf = Verfugbarkeit.new
    verf.tag = Time.new(2018, 03, 18)
    verf.save!
    verf.erzeuge_buchung_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 11, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 10), Time.mktime(2018, 03, 18, 11, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 12), Time.mktime(2018, 03, 18, 12, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 12, 59), Time.mktime(2018, 03, 18, 13, 59))
  end

  def test_buchung_moeglich
    verf = Verfugbarkeit.new
    verf.tag = Time.new(2018, 03, 18)
    verf.save!

    verf.erzeuge_buchung_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))

    assert verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 10), Time.mktime(2018, 03, 18, 10, 59))
    assert verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 13), Time.mktime(2018, 03, 18, 15))
    assert verf.buchung_moeglich?(Time.mktime(2018, 03, 19, 12), Time.mktime(2018, 03, 19, 13))
    assert verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 13, 01), Time.mktime(2018, 03, 18, 14))
  end

  def test_buchung_kuerzen_vom_start
    verf = Verfugbarkeit.new
    verf.tag = Time.new(2018, 03, 18)
    verf.save!
    verf.erzeuge_buchung_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))
    verf.erzeuge_buchung_frei(Time.mktime(2018, 03, 18, 10), Time.mktime(2018, 03, 18, 11, 30))

    assert_equal 2, verf.buchungs.size
    assert_equal Time.mktime(2018, 03, 18, 11, 31), verf.buchungs.first.reload.start
    assert_equal Time.mktime(2018, 03, 18, 12, 59), verf.buchungs.first.reload.ende
    assert_equal Time.mktime(2018, 03, 18, 10), verf.buchungs[1].reload.start
    assert_equal Time.mktime(2018, 03, 18, 11, 30), verf.buchungs[1].reload.ende
  end

  def test_buchung_kuerzen_vom_ende
    verf = Verfugbarkeit.new
    verf.tag = Time.new(2018, 03, 18)
    verf.save!
    verf.erzeuge_buchung_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))
    verf.erzeuge_buchung_besetzt(Time.mktime(2018, 03, 18, 11, 30), Time.mktime(2018, 03, 18, 13, 29))

    assert_equal 2, verf.buchungs.size
    assert_equal Time.mktime(2018, 03, 18, 11), verf.buchungs.first.start
    assert_equal Time.mktime(2018, 03, 18, 11, 29), verf.buchungs.first.ende
    assert_equal Time.mktime(2018, 03, 18, 11, 30), verf.buchungs[1].start
    assert_equal Time.mktime(2018, 03, 18, 13, 29), verf.buchungs[1].ende
  end

end
