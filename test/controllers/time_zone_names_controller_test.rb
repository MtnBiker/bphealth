require "test_helper"

class TimeZoneNamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_zone_name = time_zone_names(:one)
  end

  test "should get index" do
    get time_zone_names_url
    assert_response :success
  end

  test "should get new" do
    get new_time_zone_name_url
    assert_response :success
  end

  test "should create time_zone_name" do
    assert_difference("TimeZoneName.count") do
      post time_zone_names_url, params: { time_zone_name: { abbrev: @time_zone_name.abbrev, is_dst: @time_zone_name.is_dst, name: @time_zone_name.name, utc_offset: @time_zone_name.utc_offset } }
    end

    assert_redirected_to time_zone_name_url(TimeZoneName.last)
  end

  test "should show time_zone_name" do
    get time_zone_name_url(@time_zone_name)
    assert_response :success
  end

  test "should get edit" do
    get edit_time_zone_name_url(@time_zone_name)
    assert_response :success
  end

  test "should update time_zone_name" do
    patch time_zone_name_url(@time_zone_name), params: { time_zone_name: { abbrev: @time_zone_name.abbrev, is_dst: @time_zone_name.is_dst, name: @time_zone_name.name, utc_offset: @time_zone_name.utc_offset } }
    assert_redirected_to time_zone_name_url(@time_zone_name)
  end

  test "should destroy time_zone_name" do
    assert_difference("TimeZoneName.count", -1) do
      delete time_zone_name_url(@time_zone_name)
    end

    assert_redirected_to time_zone_names_url
  end
end
