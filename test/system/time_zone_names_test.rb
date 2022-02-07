require "application_system_test_case"

class TimeZoneNamesTest < ApplicationSystemTestCase
  setup do
    @time_zone_name = time_zone_names(:one)
  end

  test "visiting the index" do
    visit time_zone_names_url
    assert_selector "h1", text: "Time zone names"
  end

  test "should create time zone name" do
    visit time_zone_names_url
    click_on "New time zone name"

    fill_in "Abbrev", with: @time_zone_name.abbrev
    check "Is dst" if @time_zone_name.is_dst
    fill_in "Name", with: @time_zone_name.name
    fill_in "Utc offset", with: @time_zone_name.utc_offset
    click_on "Create Time zone name"

    assert_text "Time zone name was successfully created"
    click_on "Back"
  end

  test "should update Time zone name" do
    visit time_zone_name_url(@time_zone_name)
    click_on "Edit this time zone name", match: :first

    fill_in "Abbrev", with: @time_zone_name.abbrev
    check "Is dst" if @time_zone_name.is_dst
    fill_in "Name", with: @time_zone_name.name
    fill_in "Utc offset", with: @time_zone_name.utc_offset
    click_on "Update Time zone name"

    assert_text "Time zone name was successfully updated"
    click_on "Back"
  end

  test "should destroy Time zone name" do
    visit time_zone_name_url(@time_zone_name)
    click_on "Destroy this time zone name", match: :first

    assert_text "Time zone name was successfully destroyed"
  end
end
