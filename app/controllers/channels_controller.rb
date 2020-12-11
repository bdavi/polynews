# frozen_string_literal: true

class ChannelsController < SecureController
  before_action :set_channel, only: %i[show edit update destroy]

  def index
    @channels = Channel.all.includes(:category).order(:title).page(params[:page])
  end

  def show; end

  def new
    @channel = Channel.new
  end

  def edit; end

  def create
    @channel = Channel.new(channel_params)

    if @channel.save
      redirect_to @channel, success: 'Successfully created channel'
    else
      render :new
    end
  end

  def update
    if @channel.update(channel_params)
      redirect_to @channel, success: 'Successfully updated channel'
    else
      render :edit
    end
  end

  def destroy
    @channel.destroy
    redirect_to channels_url, success: 'Successfully deleted channel'
  end

  private

  def set_channel
    @channel = Channel.includes(:category, :articles).find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(
      :category_id,
      :description,
      :image_url,
      :last_build_date,
      :scraping_content_selector,
      :title,
      :url,
      :use_scraper
    )
  end
end
