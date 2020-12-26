# frozen_string_literal: true

class ArticlesController < SecureController
  before_action :set_article, only: %i[show edit update destroy]

  def index # rubocop:disable Metrics/MethodLength
    @articles = Article
                  .includes(:channel, :group)
                  .select(
                    :id,
                    :title,
                    :published_at,
                    :description,
                    :url,
                    :channel_id,
                    :group_id,
                    :primary_image_url,
                    :thumbnail_image_url
                  )
                  .order(:created_at)
                  .page(params[:page])
  end

  def show; end

  def update
    if @article.update(article_params)
      redirect_to @article, success: 'Successfully updated article'
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
      redirect_to @article, success: 'Successfully created article'
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
    @article = Article.includes(:channel, :group).find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def article_params
    params.require(:article).permit(
      :channel_id,
      :content,
      :description,
      :guid,
      :primary_image_url,
      :thumbnail_image_url,
      :published_at,
      :scraped_content,
      :title,
      :url
    )
  end
  # rubocop:enable Metrics/MethodLength
end
