require 'test_helper'

class PrinziCalControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get prinzi_cal_index_url
    assert_response :success
  end

end
