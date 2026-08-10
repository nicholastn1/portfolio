require "test_helper"

class Admin::PositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    User.create!(name: "Admin", email: "admin@test.dev", password: "secret123")
    post admin_login_path, params: { email: "admin@test.dev", password: "secret123" }

    Skill.delete_all
    @skills = 25.times.map do |i|
      Skill.create!(name: "skill-#{i}", category: "backend", proficiency: "proficient", position: i + 1)
    end
  end

  test "reordering page 2 leaves page 1 untouched and positions unique" do
    page_two = @skills.last(5).map(&:id)

    patch admin_reorder_path(resource: "skills"), params: { ids: page_two.reverse }, as: :json

    assert_response :no_content
    positions = Skill.pluck(:position)
    assert_equal positions.uniq.size, positions.size

    assert_equal @skills.first(20).map(&:id), Skill.order(:position).limit(20).pluck(:id)
    assert_equal page_two.reverse, Skill.order(:position).offset(20).pluck(:id)
  end

  test "rejects unknown resources and unknown ids" do
    patch admin_reorder_path(resource: "users"), params: { ids: [ 1 ] }, as: :json
    assert_response :bad_request

    patch admin_reorder_path(resource: "skills"), params: { ids: [ @skills.first.id, -1 ] }, as: :json
    assert_response :bad_request
  end
end
