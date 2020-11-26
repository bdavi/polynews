# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pipeline::Base do
  describe '.call' do
    it 'applies the operations and returns the result' do
      pipeline = Class.new(described_class) do
        use ->(str) { str.strip }
        use ->(str) { str.downcase }
      end

      result = pipeline.call('   HeLLo, WorLd  ')

      expect(result).to eq 'hello, world'
    end
  end
end
