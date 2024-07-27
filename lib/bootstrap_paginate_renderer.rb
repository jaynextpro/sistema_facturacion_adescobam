require 'will_paginate/view_helpers/action_view'

class BootstrapPaginateRenderer < WillPaginate::ActionView::LinkRenderer
  def container_attributes
    { class: 'pagination' }
  end

  def page_number(page)
    if page == current_page
      tag(:li, tag(:span, page, class: 'page-link'), class: 'page-item active')
    else
      tag(:li, link(page, page, class: 'page-link'), class: 'page-item')
    end
  end

  def gap
    tag(:li, tag(:span, '...', class: 'page-link'), class: 'page-item disabled')
  end

  def previous_or_next_page(page, text, classname, aria_label)
    classname = classname == 'previous_page' ? 'page-item previous' : 'page-item next'
    if page
      tag(:li, link(text, page, class: 'page-link', 'aria-label': aria_label), class: classname)
    else
      tag(:li, tag(:span, text, class: 'page-link', 'aria-label': aria_label), class: "#{classname} disabled")
    end
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, '<', 'page-item previous', 'Previous')
  end

  def next_page
    num = @collection.current_page < total_pages && @collection.current_page + 1
    previous_or_next_page(num, '>', 'page-item next', 'Next')
  end

  def first_page
    num = @collection.current_page > 1 && 1
    previous_or_next_page(num, 'Primera', 'page-item first', 'Primero')
  end

  def last_page
    num = @collection.current_page < total_pages && total_pages
    previous_or_next_page(num, 'Última', 'page-item last', 'Último')
  end

  def to_html
    list_items = first_page + windowed_page_numbers.map { |page| page_number(page) }.join + last_page
    html_container(list_items)
  end

  def html_container(html)
    tag(:nav, tag(:ul, html, container_attributes))
  end
end
