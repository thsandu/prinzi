require 'test_helper'

class BuchungsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @buchung = buchungs(:one)
  end

  test "should get index" do
    get buchungs_url
    assert_response :success
  end

  test "should get new" do
    get new_buchung_url
    assert_response :success
  end

  test "should create buchung" do
    assert_difference('Buchung.count') do
      verf_id = verfugbarkeits(:one).id
      post buchungs_url, params: {buchung: { ende: @buchung.ende, start: @buchung.start, status: @buchung.status, typ: @buchung.typ } }
    end

    assert_redirected_to buchung_url(Buchung.last)
  end

  test "should show buchung" do
    get buchung_url(@buchung)
    assert_response :success
  end

  test "should get edit" do
    get edit_buchung_url(@buchung)
    assert_response :success
  end

  test "should update buchung" do
    patch buchung_url(@buchung), params: { buchung: { ende: @buchung.ende, start: @buchung.start, status: @buchung.status, typ: @buchung.typ }  }
    assert_redirected_to buchung_url(@buchung)
  end

  test "should destroy buchung" do
    assert_difference('Buchung.count', -1) do
      delete buchung_url(@buchung)
    end

    assert_redirected_to buchungs_url
  end
end
