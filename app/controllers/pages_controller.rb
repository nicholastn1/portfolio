class PagesController < ApplicationController
  def home
    @personal_info = PersonalInfo.instance
    @experiences = Experience.all
    @educations = Education.all
    @certifications = Certification.all
    @volunteerings = Volunteering.all
    @skills = Skill.all
    @projects = Project.all
    @languages = Language.all
  end
end
