require 'test_helper'

class Api::HomePostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_home_posts_index_url
    assert_response :success
  end

end
