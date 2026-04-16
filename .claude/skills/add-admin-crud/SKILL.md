# Skill: Add Admin CRUD for a New Model

## When to Use

- Adding a new content type that needs admin management
- Creating a new model with full CRUD in the admin panel

## Steps

### 1. Generate Migration

```bash
bin/rails generate migration CreateModelNames field_pt:string field_en:string position:integer ...
bin/rails db:migrate
```

For bilingual fields, always create both `_pt` and `_en` columns.

### 2. Create the Model

`app/models/model_name.rb`:

```ruby
class ModelName < ApplicationRecord
  include Localizable
  localized_field :field  # generates accessor resolving _pt/_en by locale

  validates :field_pt, presence: true
  default_scope { order(position: :asc) }
end
```

### 3. Create the Admin Controller

`app/controllers/admin/model_names_controller.rb`:

```ruby
module Admin
  class ModelNamesController < BaseController
    before_action :set_model_name, only: %i[edit update destroy]

    def index
      @pagy, @model_names = pagy(ModelName.all, limit: 20)
    end

    def new
      @model_name = ModelName.new
    end

    def create
      @model_name = ModelName.new(model_name_params)
      if @model_name.save
        redirect_to admin_model_names_path, notice: "Created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @model_name.update(model_name_params)
        redirect_to admin_model_names_path, notice: "Updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @model_name.destroy
      redirect_to admin_model_names_path, notice: "Deleted successfully."
    end

    private

    def set_model_name
      @model_name = ModelName.find(params[:id])
    end

    def model_name_params
      params.require(:model_name).permit(:field_pt, :field_en, :position)
    end
  end
end
```

### 4. Create Admin Views

Create four files in `app/views/admin/model_names/`:

- `index.html.erb` — Table listing with edit/delete buttons, Pagy pagination
- `new.html.erb` — Form wrapper with "New" heading
- `edit.html.erb` — Form wrapper with "Edit" heading
- `_form.html.erb` — Shared form partial using `admin/shared/_form_field` helper

Follow the pattern from existing admin views (e.g., `app/views/admin/experiences/`).

### 5. Add Route

In `config/routes.rb` inside the `namespace :admin` block:

```ruby
resources :model_names
```

### 6. Add Admin Nav Link

In `app/views/layouts/admin.html.erb`, add a navigation link using the `admin_nav_link` helper:

```erb
<%= admin_nav_link "Model Names", admin_model_names_path, "model_name" %>
```

### 7. Add Seed Data

In `db/seeds.rb`, add seed entries following the `find_or_create_by!` pattern:

```ruby
ModelName.find_or_create_by!(field_pt: "...") do |m|
  m.assign_attributes(field_en: "...", position: 1)
end
```

### 8. JSON Array Fields

For fields that store arrays (achievements, technologies, activities), use JSON columns and parse in the controller:

```ruby
def model_name_params
  params.require(:model_name).permit(:field).tap do |p|
    p[:technologies] = p[:technologies]&.split(",")&.map(&:strip)&.reject(&:blank?) if p[:technologies].is_a?(String)
  end
end
```

### Patterns to Follow

- Admin controllers inherit from `Admin::BaseController` (provides auth)
- Layout is `admin` (set in BaseController)
- Pagination: `@pagy, @records = pagy(scope, limit: 20)`
- Flash messages: `notice:` for success, `alert:` for errors
- All bilingual fields need both `_pt` and `_en` form inputs
- Edit/delete buttons aligned horizontally in index tables
