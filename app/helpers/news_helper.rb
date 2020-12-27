# frozen_string_literal: true

module NewsHelper
  def navitem_class(slug, request)
    if request.path.start_with? "/news/#{slug}"
      'nav-link active'
    else
      'nav-link'
    end
  end

  def article_meta(article)
    title = tag.span(
      article.decorate.channel_title,
      class: 'text-uppercase text-accent-color'
    )

    published_at = tag.span(
      local_time_ago(article.decorate.published_at),
      class: 'font-italic small'
    )

    tag.div(title + ' '.html_safe + published_at)
  end

  def article_title_link(article)
    tag.div(class: 'article-title') do
      link_to article.title, article.url, target: '_blank' # rubocop:disable Rails/LinkToBlank
    end
  end
end
