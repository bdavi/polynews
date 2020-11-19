# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/channels', type: :request do
  describe 'GET /index' do
    it 'renders a successful response' do
      create(:channel)

      get channels_url

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      channel = create(:channel)

      get channel_url(channel)

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_channel_url

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      channel = create(:channel)

      get edit_channel_url(channel)

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Channel' do
        expect do
          post channels_url, params: { channel: attributes_for(:channel) }
        end.to change(Channel, :count).by(1)
      end

      it 'redirects to the created channel' do
        post channels_url, params: { channel: attributes_for(:channel) }

        expect(response).to redirect_to(channel_url(Channel.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Channel' do
        expect do
          post channels_url, params: { channel: attributes_for(:channel, :invalid) }
        end.to change(Channel, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post channels_url, params: { channel: attributes_for(:channel, :invalid) }

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested channel' do
        channel = create(:channel)

        patch channel_url(channel), params: { channel: { title: 'abc123' } }
        channel.reload

        expect(channel.title).to eq 'abc123'
      end

      it 'redirects to the channel' do
        channel = create(:channel)

        patch channel_url(channel), params: { channel: { title: 'abc123' } }
        channel.reload

        expect(response).to redirect_to(channel_url(channel))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        channel = create(:channel)

        patch channel_url(channel), params: { channel: { title: nil } }

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested channel' do
      channel = create(:channel)

      expect do
        delete channel_url(channel)
      end.to change(Channel, :count).by(-1)
    end

    it 'redirects to the channels list' do
      channel = create(:channel)

      delete channel_url(channel)

      expect(response).to redirect_to(channels_url)
    end
  end
end
