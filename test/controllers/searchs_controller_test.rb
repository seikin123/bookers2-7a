require 'test_helper'

class SearchsControllerTest < ActionDispatch::IntegrationTest
  test "should get seach" do
    get searchs_seach_url
    assert_response :success
  end

end
