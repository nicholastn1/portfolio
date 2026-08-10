module Admin
  class PositionsController < BaseController
    MODELS = {
      "certifications" => Certification,
      "educations" => Education,
      "experiences" => Experience,
      "languages" => Language,
      "projects" => Project,
      "skills" => Skill,
      "social_links" => SocialLink,
      "volunteerings" => Volunteering
    }.freeze

    def update
      model = MODELS[params[:resource]]
      return head :bad_request unless model

      ids = Array(params[:ids]).map(&:to_i)
      records = model.reorder(:position, :id).to_a
      moved = records.select { |r| ids.include?(r.id) }.index_by(&:id)
      return head :bad_request unless moved.size == ids.size

      # Splice the submitted order into the slots those records already occupy,
      # so reordering page 2 never collides with page 1.
      queue = ids.map { |id| moved[id] }
      model.transaction do
        records.each_with_index do |record, i|
          (moved.key?(record.id) ? queue.shift : record).update_column(:position, i + 1)
        end
      end

      head :no_content
    end
  end
end
