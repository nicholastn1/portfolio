require "test_helper"

class PaginationTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Admin", email: "admin@test.dev", password: "secret123")
    Post.delete_all
    12.times do |i|
      Post.create!(
        user: @user,
        title_pt: "post-#{i}",
        category: "engineering",
        published: true,
        published_at: i.days.ago
      )
    end
  end

  test "blog paginates and renders the nav" do
    get posts_path
    assert_response :success
    assert_select "a[href=?]", "#{posts_path}?page=2"

    get posts_path(page: 2)
    assert_response :success
    # 12 posts, 9 per page, newest first: page 2 holds the 3 oldest
    assert_includes response.body, "post-11"
    assert_not_includes response.body, "post-0<"
  end

  test "out of range page does not blow up" do
    get posts_path(page: 999)
    assert_response :success
  end

  test "admin index paginates" do
    post admin_login_path, params: { email: "admin@test.dev", password: "secret123" }

    get admin_posts_path
    assert_response :success
    assert_select "a[href=?]", "#{admin_posts_path}?page=2"
  end
end
