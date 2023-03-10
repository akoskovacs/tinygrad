# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe TinyGrad::Graph do
  let(:a) { TinyGrad::Value.new(2, label: "a") }
  let(:b) { TinyGrad::Value.new(-3, label: "b") }
  let(:c) { TinyGrad::Value.new(10, label: "c") }
  let(:e) { e = a * b ; e.label = 'e' ; e }
  let(:d) { d = e + c ; d.label = 'd' ; d }
  subject { described_class.new }

  it { is_expected.to respond_to(:draw) }
  it { is_expected.to respond_to(:nodes) }
  it { is_expected.to respond_to(:edges) }

  describe "#draw" do
    let(:test_file_name) { "test_file.svg" }

    it "raises error when an empty file name is passed" do
      expect do
        subject.draw(d, file_name: "")
      end.to raise_error(ArgumentError, "No output file is given")
    end

    it "raises error when an empty file name is passed" do
      expect do
        subject.draw(nil, file_name: "aaa.svg")
      end.to raise_error(ArgumentError, "Not a TinyGrad::Value")
    end

    it "has to create an svg file" do
      subject.draw(d, file_name: test_file_name)
      expect(File.exist?(test_file_name)).to be_truthy
    end
  end
end
