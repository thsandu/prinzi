require "application_system_test_case"

class BuchungsTest < ApplicationSystemTestCase
  setup do
    @buchung = buchungs(:one)
  end

  test "visiting the index" do
    visit buchungs_url
    assert_selector "h1", text: "Buchungs"
  end

  test "creating a Buchung" do
    visit buchungs_url
    click_on "New Buchung"

    fill_in "Ende", with: @buchung.ende
    fill_in "Start", with: @buchung.start
    fill_in "Status", with: @buchung.status
    fill_in "Verfugbarkeit", with: @buchung.verfugbarkeit_id
    click_on "Create Buchung"

    assert_text "Buchung was successfully created"
    click_on "Back"
  end

  test "updating a Buchung" do
    visit buchungs_url
    click_on "Edit", match: :first

    fill_in "Ende", with: @buchung.ende
    fill_in "Start", with: @buchung.start
    fill_in "Status", with: @buchung.status
    fill_in "Verfugbarkeit", with: @buchung.verfugbarkeit_id
    click_on "Update Buchung"

    assert_text "Buchung was successfully updated"
    click_on "Back"
  end

  test "destroying a Buchung" do
    visit buchungs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Buchung was successfully destroyed"
  end
end
