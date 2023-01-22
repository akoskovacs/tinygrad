# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe TinyGrad::Operation do
  subject { described_class.new }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:empty?) }
  it { is_expected.to respond_to(:to_s) }

  describe '#empty?' do
    context 'when no operations are provided' do
      subject { described_class.new('') }

      it { expect(subject.empty?).to be_truthy }
    end

    context 'when an operation is provided' do
      subject { described_class.new('+') }

      it { expect(subject.empty?).to be_falsy }
    end
  end

  describe '#to_s' do
    subject { described_class.new('*') }

    it 'serializes to the right operation' do
      expect(subject.to_s).to eq('*')
    end
  end

  describe '#name' do
    subject { described_class.new('*') }

    it 'gives the right name' do
      expect(subject.name).to eq('*')
    end
  end
end
