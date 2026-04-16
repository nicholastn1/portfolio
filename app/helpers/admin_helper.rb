module AdminHelper
  def admin_nav_link(label, path, controller_name)
    active = controller.controller_name == controller_name.pluralize || controller.controller_name == controller_name
    css = if active
      "flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium text-white bg-white/10"
    else
      "flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-text-muted hover:text-white hover:bg-white/5 transition-all"
    end
    link_to label, path, class: css
  end
end
