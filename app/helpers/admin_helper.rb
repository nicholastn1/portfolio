module AdminHelper
  def admin_nav_link(label, path, controller_name, section_id: nil)
    active = controller.controller_name == controller_name.pluralize ||
             controller.controller_name == controller_name

    base = "group flex items-center justify-between px-3 py-2 text-sm transition-colors duration-150 border-l-2"

    css = if active
      "#{base} text-paper bg-paper/10 border-signal"
    else
      "#{base} text-paper/60 hover:text-paper hover:bg-paper/[0.04] border-transparent"
    end

    link_to(path, class: css) do
      content_tag(:span, label) +
        if section_id
          content_tag(
            :span,
            section_id,
            class: "font-mono text-[0.65rem] tracking-[0.14em] text-paper/40 group-hover:text-signal"
          )
        else
          "".html_safe
        end
    end
  end

  def admin_section_label(text)
    content_tag(
      :div,
      text,
      class: "px-3 pt-5 pb-2 font-mono text-[0.65rem] tracking-[0.18em] uppercase text-paper/35"
    )
  end
end
