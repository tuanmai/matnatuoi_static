module ApplicationHelper
  def new_sidebar_section_for(title, &block)
    content_tag(:div, class:'mdl-cell mdl-cell--12-col mdl-card sidebar-card') do
      content_tag(:div, class: 'mdl-card__title') do
        content_tag(:span, class: '') { title }
      end +
      content_tag(:div, class: 'mdl-card__supporting-text') do
        capture(&block)
      end
    end
  end
end
