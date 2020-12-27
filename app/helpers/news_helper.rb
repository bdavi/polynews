# frozen_string_literal: true

module NewsHelper
  def navitem_class(slug, request)
    if request.path.start_with? "/news/#{slug}"
      'nav-link active'
    else
      'nav-link'
    end
  end

  def story_meta(story, title_classes: 'text-uppercase text-accent-color')
    title = tag.span(
      story.decorate.channel_title,
      class: title_classes
    )

    published_at = tag.span(
      local_time_ago(story.decorate.published_at),
      class: 'font-italic small'
    )

    tag.div(title + ' ' + published_at) # rubocop:disable Style/StringConcatenation
  end

  def story_title_link(story, div_classes: 'story-title')
    tag.div(class: div_classes) do
      link_to story.title, story.url, target: '_blank' # rubocop:disable Rails/LinkToBlank
    end
  end

  def page_data(collection)
    tag.div(
      class: 'd-none story-grid-page-data',
      data: {
        'current-page': collection.current_page,
        'total-pages': collection.total_pages,
        'next-page-url': path_to_next_page(collection)
      }
    )
  end
end
