# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe TinyGrad::Neuron do
  subject { described_class.new(10) }

  it_should_behave_like "AI"
end
