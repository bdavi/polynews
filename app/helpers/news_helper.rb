# frozen_string_literal: true

module NewsHelper
  def navitem_class(slug, request)
    if request.path.start_with? "/news/#{slug}"
      'nav-link active'
    else
      'nav-link'
    end
  end
end
