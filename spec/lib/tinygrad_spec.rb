# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe TinyGrad do
  it "has a version number" do
    expect(TinyGrad::VERSION).not_to be nil
  end
end
