# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article
                  .includes(:channel)
                  .order(:created_at)
                  .page(params[:page])
  end

  def show; end

  def update
    if @article.update(article_params)
      redirect_to article_path(@article), success: 'Successfully updated article'
    else
      render :edit
    end
  end

  def edit; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to article_path(@article), success: 'Successfully updated article'
    else
      render :new
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, success: 'Successfully deleted article'
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(
      :channel_id,
      :content,
      :description,
      :guid,
      :published_at,
      :title
    )
  end
end
