require 'test_helper'

class VerfugbarkeitTest < ActiveSupport::TestCase
  fixtures :verfugbarkeits

  test "test_find_verfugbarkeit_by_gcalid" do
    buchungen_with_gid = Verfugbarkeit.where({ gcal_id: ['6s00hbpqq865cci7k1rndra7vo']})

    event_array = (buchungen_with_gid.size > 1)
    next_events = buchungen_with_gid.to_a

    refute event_array
    assert_equal "verfügbar", next_events.first.status

  end

  def test_create_frei_Verfugbarkeit
    ab_zeit = Time.mktime(2018, 03, 18, 10)
    bis_zeit = Time.mktime(2018, 03, 18, 12)
    buchung = Verfugbarkeit.new
    buchung.befreie_zeitraum(ab_zeit, bis_zeit)

    start_here = buchung.start.in_time_zone('Europe/Bucharest')
    ende_here = buchung.ende.in_time_zone('Europe/Bucharest')


    assert_equal 10, start_here.hour
    assert_equal 00, start_here.min
    assert_equal 12, ende_here.hour
    assert_equal 00, ende_here.min
    assert_equal 'frei', buchung.status
  end

  def test_create_besetzt_Verfugbarkeit
    buchung = Verfugbarkeit.new
    ab_zeit = Time.mktime(2018, 03, 18, 11)
    bis_zeit = Time.mktime(2018, 03, 18, 13)
    buchung.besetze_zeitraum(ab_zeit, bis_zeit)

    start_here = buchung.start.in_time_zone('Europe/Bucharest')
    ende_here = buchung.ende.in_time_zone('Europe/Bucharest')

    assert_equal '11:00', start_here.strftime("%H:%M")
    assert_equal '13:00', ende_here.strftime("%H:%M")
    assert_equal 'besetzt', buchung.status
  end

  def test_Verfugbarkeit_one_verfugbarkeit_frei
    verf = Verfugbarkeit.new
    verf.erzeuge_verfugbarkeit_frei(Time.mktime(2018, 03, 18, 10, 30), Time.mktime(2018, 03, 18, 12, 30))

    assert_equal '10:30 EET', verf.start.strftime("%H:%M %Z")
    assert_equal '12:30 EET', verf.ende.strftime("%H:%M %Z")
  end

  def test_Verfugbarkeit_two_verfugbarkeit_frei
    start1 = Time.mktime(2018, 01, 01, 10, 30)
    start2 = Time.mktime(2018, 01, 01, 12, 30)
    ende1 = Time.mktime(2018, 01, 01, 12, 29)
    ende2 = Time.mktime(2018, 01, 01, 14, 29)
    verf1 = Verfugbarkeit.new.erzeuge_verfugbarkeit_frei(start1, ende1)
    verf2 = Verfugbarkeit.new.erzeuge_verfugbarkeit_frei(start2, ende2)

    assert_equal start1, verf1.start
    assert_equal start2, verf2.start
    assert_equal ende1, verf1.ende
    assert_equal ende2, verf2.ende

  end

  def test_verfugbarkeit_moeglich_negative
    verf = Verfugbarkeit.new
    verf.erzeuge_verfugbarkeit_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 11, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 10), Time.mktime(2018, 03, 18, 11, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 12), Time.mktime(2018, 03, 18, 12, 59))
    # assert_false verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 12, 59), Time.mktime(2018, 03, 18, 13, 59))
  end

  test "test_verfugbarkeit_moeglich" do
    verf = Verfugbarkeit.new

    verf.erzeuge_verfugbarkeit_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))

    # assert verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 10), Time.mktime(2018, 03, 18, 10, 59))
    # assert verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 13), Time.mktime(2018, 03, 18, 15))
    # assert verf.buchung_moeglich?(Time.mktime(2018, 03, 19, 12), Time.mktime(2018, 03, 19, 13))
    # assert verf.buchung_moeglich?(Time.mktime(2018, 03, 18, 13, 01), Time.mktime(2018, 03, 18, 14))
  end

  def test_verfugbarkeit_kuerzen_vom_start
    verf1 = Verfugbarkeit.new.erzeuge_verfugbarkeit_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))
    verf2 = Verfugbarkeit.new.erzeuge_verfugbarkeit_frei(Time.mktime(2018, 03, 18, 10), Time.mktime(2018, 03, 18, 11, 30))

    assert_equal Time.mktime(2018, 03, 18, 11, 31), verf1.reload.start
    assert_equal Time.mktime(2018, 03, 18, 12, 59), verf1.reload.ende
    assert_equal Time.mktime(2018, 03, 18, 10), verf2.reload.start
    assert_equal Time.mktime(2018, 03, 18, 11, 30), verf2.reload.ende
  end

  test "test_verfugbarkeit_kuerzen_vom_ende" do
    verf1 = Verfugbarkeit.new.erzeuge_verfugbarkeit_frei(Time.mktime(2018, 03, 18, 11), Time.mktime(2018, 03, 18, 12, 59))
    verf2 = Verfugbarkeit.new.erzeuge_verfugbarkeit_besetzt(Time.mktime(2018, 03, 18, 11, 30), Time.mktime(2018, 03, 18, 13, 29))

    assert_equal Time.mktime(2018, 03, 18, 11), verf1.start
    assert_equal Time.mktime(2018, 03, 18, 11, 29), verf1.ende
    assert_equal Time.mktime(2018, 03, 18, 11, 30), verf2.buchung.start
    assert_equal Time.mktime(2018, 03, 18, 13, 29), verf2.ende
  end


end
