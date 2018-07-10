require "application_system_test_case"

class VerfugbarkeitsTest < ApplicationSystemTestCase
  setup do
    @verfugbarkeit = verfugbarkeits(:one)
  end

  test "visiting the index" do
    visit verfugbarkeits_url
    assert_selector "h1", text: "Verfugbarkeits"
  end

  test "creating a Verfugbarkeit" do
    visit verfugbarkeits_url
    click_on "New Verfugbarkeit"

    fill_in "Tag", with: @verfugbarkeit.tag
    click_on "Create Verfugbarkeit"

    assert_text "Verfugbarkeit was successfully created"
    click_on "Back"
  end

  test "updating a Verfugbarkeit" do
    visit verfugbarkeits_url
    click_on "Edit", match: :first

    fill_in "Tag", with: @verfugbarkeit.tag
    click_on "Update Verfugbarkeit"

    assert_text "Verfugbarkeit was successfully updated"
    click_on "Back"
  end

  test "destroying a Verfugbarkeit" do
    visit verfugbarkeits_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Verfugbarkeit was successfully destroyed"
  end
end
