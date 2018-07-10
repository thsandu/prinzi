require 'test_helper'

class VerfugbarkeitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @verfugbarkeit = verfugbarkeits(:one)
  end

  test "should get index" do
    get verfugbarkeits_url
    assert_response :success
  end

  test "should get new" do
    get new_verfugbarkeit_url
    assert_response :success
  end

  test "should create verfugbarkeit" do
    assert_difference('Verfugbarkeit.count') do
      post verfugbarkeits_url, params: { verfugbarkeit: { tag: @verfugbarkeit.tag } }
    end

    assert_redirected_to verfugbarkeit_url(Verfugbarkeit.last)
  end

  test "should show verfugbarkeit" do
    get verfugbarkeit_url(@verfugbarkeit)
    assert_response :success
  end

  test "should get edit" do
    get edit_verfugbarkeit_url(@verfugbarkeit)
    assert_response :success
  end

  test "should update verfugbarkeit" do
    patch verfugbarkeit_url(@verfugbarkeit), params: { verfugbarkeit: { tag: @verfugbarkeit.tag } }
    assert_redirected_to verfugbarkeit_url(@verfugbarkeit)
  end

  test "should destroy verfugbarkeit" do
    assert_difference('Verfugbarkeit.count', -1) do
      delete verfugbarkeit_url(@verfugbarkeit)
    end

    assert_redirected_to verfugbarkeits_url
  end
end
