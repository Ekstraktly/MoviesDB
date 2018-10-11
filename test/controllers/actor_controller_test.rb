require 'test_helper'

class ActorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get actor_index_url
    assert_response :success
  end

end
