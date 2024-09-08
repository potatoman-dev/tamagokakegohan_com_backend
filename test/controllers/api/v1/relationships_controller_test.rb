require "test_helper"

class Api::V1::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get followings" do
    get api_v1_relationships_followings_url
    assert_response :success
  end

  test "should get followers" do
    get api_v1_relationships_followers_url
    assert_response :success
  end
end
