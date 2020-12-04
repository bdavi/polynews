# frozen_string_literal: true

class NewsController < ApplicationController
  layout 'news'

  def show
    @news = News.new(params)
  end
end
