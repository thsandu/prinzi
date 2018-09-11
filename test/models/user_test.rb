require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:jutta_user)
  end

  test "berechne verfügbarkeit am tag" do
    auslastungen = @user.berechne_verf_am_tag(Time.mktime(2018, 8, 7, 0), Time.mktime(2018, 8, 8, 0))
    assert_equal(2, auslastungen[:verfügbar].length)
    assert_equal(1, auslastungen[:abwesend].length)
    assert_equal(1, auslastungen[:fragen].length)
  end

end
