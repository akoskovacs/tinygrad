RSpec.shared_examples 'AI' do
  let(:parameter) do
    (1..10).map { |x| TinyGrad::Value.new(x.to_f) }
  end

  it { expect(subject).to respond_to(:call) }
  it { expect(subject.call(parameter)).to be_a(TinyGrad::Value) }
end
