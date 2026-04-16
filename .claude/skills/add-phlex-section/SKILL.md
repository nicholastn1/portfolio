# Skill: Add a New Phlex Section Component

## When to Use

- Adding a new section to the public portfolio homepage
- Creating a reusable UI component for the public site

## Steps

### 1. Create the Component

Create a new file in `app/components/sections/` following the naming convention `{name}_section.rb`:

```ruby
# frozen_string_literal: true

class Components::Sections::NewSection < Components::Base
  def initialize(data:)
    @data = data
  end

  def view_template
    section(
      id: "section-id",
      class: "py-20 px-6 md:px-12 lg:px-24",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-4xl mx-auto") do
        render_section_title
        render_content
      end
    end
  end

  private

  def render_section_title
    h2(class: "text-3xl md:text-4xl font-bold text-white mb-12") do
      plain "Section Title"
      span(class: "text-accent-green") { "." }
    end
  end

  def render_content
    # Component content here
  end
end
```

### 2. Pass Data from Controller

Update `app/controllers/pages_controller.rb` to load the data:

```ruby
def home
  # ... existing loads ...
  @new_data = NewModel.all
end
```

### 3. Render in Homepage

Add the component to `app/views/pages/home.html.erb`:

```erb
<%= render Components::Sections::NewSection.new(data: @new_data) %>
```

### 4. Patterns to Follow

- **Constructor injection**: All data passed via `initialize`, never use instance variables from the controller
- **Private render methods**: Break the template into `render_*` private methods for readability
- **Tailwind classes**: Use the project's custom tokens (`bg-bg-dark`, `text-accent-green`, `text-text-muted`, `bg-gradient-primary`)
- **Scroll animation**: Add `data: { controller: "scroll-animation" }` to the section for entrance animations
- **Section ID**: Always add an `id` attribute for anchor link navigation
- **Bilingual**: Use `model.field` (via Localizable) instead of `model.field_pt` directly — it resolves based on locale

### 5. Reusable UI Components

For smaller UI elements, place them in `app/components/ui/`:

```ruby
class Components::Ui::NewWidget < Components::Base
  def initialize(text:, variant: :default)
    @text = text
    @variant = variant
  end

  def view_template
    # ...
  end
end
```

Render from other components: `render Components::Ui::NewWidget.new(text: "Hello")`
