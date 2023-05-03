require "test_helper"

class RecommenderControllerTest < ActionDispatch::IntegrationTest
  test "should get category" do
    get recommender_category_url
    assert_response :success
  end

  test "should get articles" do
    get recommender_articles_url
    assert_response :success
  end

  test "should get result" do
    get recommender_result_url
    assert_response :success
  end
end
