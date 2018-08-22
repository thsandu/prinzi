require 'test_helper'

class VerfugbarkeitTest < ActiveSupport::TestCase
  fixtures :verfugbarkeits

  test "find_by_date" do

    verf_gefunden = Verfugbarkeit.where(["tag = ?", Time.utc(2018,07,07)])
    assert_equal verfugbarkeits(:one).id, verf_gefunden.ids.first
  end

end
