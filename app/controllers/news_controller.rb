# frozen_string_literal: true

class NewsController < ApplicationController
  layout 'news'

  def index
    @news = News.new(params)

    respond_to do |format|
      format.html { render :index }
      format.js   { render :index }
    end
  end
end
