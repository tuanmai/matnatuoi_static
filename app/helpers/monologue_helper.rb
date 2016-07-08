module MonologueHelper
  def new_new_sidebar_section_for(title, &block)
    content_tag(:div, class:'mdl-cell mdl-cell--12-col mdl-card mdl-shadow--4dp portfolio-card') do
      content_tag(:div, class: 'mdl-card__title') do
        content_tag(:h3, class: 'mdl-card__title-text') { title }
      end
      content_tag(:div, class: 'mdl-card__supporting-text') do
        content_tag(:ul, class: 'mdl-list') { captue(&block) }
      end
    end
  end
end
