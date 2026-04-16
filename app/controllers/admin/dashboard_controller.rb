module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        experiences: Experience.count,
        educations: Education.count,
        certifications: Certification.count,
        volunteerings: Volunteering.count,
        projects: Project.count,
        skills: Skill.count,
        languages: Language.count,
        posts: Post.count,
        published_posts: Post.published.count
      }
      @recent_posts = Post.recent.limit(5)
    end
  end
end
