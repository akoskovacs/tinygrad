# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe TinyGrad::Value do
  EPSILON = 1E4

  subject { described_class.new(1) }

  it { is_expected.to respond_to(:+) }
  it { is_expected.to respond_to(:*) }
  it { is_expected.to respond_to(:to_s) }
  it { is_expected.to respond_to(:data) }
  it { is_expected.to respond_to(:grad) }
  it { is_expected.to respond_to(:tanh) }
  it { is_expected.to respond_to(:backward) }
  it { expect(subject.data).to eq(1) }

  describe "#new" do
    xit "raises error for non-float arguments" do
      expect do
        described_class.new("wooo")
      end.to raise_error(ArgumentError, "data parameter is not a float")
    end

    it "can be labelled" do
      x = described_class.new(10, label: "x")
      expect(x.label).to be("x")
    end

    it 'defaults to 0.0 as the gradient' do
      expect(subject.grad).to be(0.0)
    end

    it "can allows label modification" do
      x = described_class.new(10, label: "x")
      expect(x.label).to be("x")
      x.label = "X"
      expect(x.label).to be("X")
    end
  end

  describe "to_s" do
    let(:with_label) { described_class.new(42, label: 'wl' ) }
    let(:with_grad) do
      x = described_class.new(8, label: 'wg' )
      x.grad = 12.0
      x
    end

    it { expect(subject.to_s).to eq("Value(data: 1.0000, grad: 0.0000)") }
    it { expect(with_label.to_s).to eq("Value(label: wl, data: 42.0000, grad: 0.0000)") }
    it { expect(with_grad.to_s).to eq("Value(label: wg, data: 8.0000, grad: 12.0000)") }
  end

  describe "+" do
    let(:a) { described_class.new(2) }
    let(:b) { described_class.new(3) }
    let(:c) { a + b }

    it "raises error if the other argument is not a float" do
      expect do
        a + 22
      end.to raise_error(ArgumentError, "right value of '+' is not a Value")
    end

    it "the type is Value" do
      expect(c).to be_a(described_class)
    end

    it "can add two numbers" do
      expect(c.data).to eq(5.0)
    end

    it "has the right children" do
      expect(c.children[0]).to eq(a)
      expect(c.children[1]).to eq(b)
    end

    it "has the right operation" do
      expect(c.op.name).to eq("+")
    end
  end

  describe "*" do
    let(:a) { described_class.new(2) }
    let(:b) { described_class.new(3) }
    let(:c) { a * b }

    it "raises error if the other argument is not a float" do
      expect do
        a * 22
      end.to raise_error(ArgumentError, "right value of '*' is not a Value")
    end

    it "the type is Value" do
      expect(c).to be_a(described_class)
    end

    it "can multiply two numbers" do
      expect(c.data).to eq(6.0)
    end

    it "has the right children" do
      expect(c.children[0]).to eq(a)
      expect(c.children[1]).to eq(b)
    end

    it "has the right operation" do
      expect(c.op.name).to eq("*")
    end
  end

  describe "#tanh" do
    let(:a) { described_class.new(1.3) }
    subject { a.tanh }

    it "the type is Value" do
      expect(subject).to be_a(described_class)
    end

    it "has the right children" do
      expect(subject.children[0]).to eq(a)
      expect(subject.children.size).to eq(1)
    end

    it "calculates tanh() correctly" do
      expect(subject.data).to be_within(EPSILON).of(0.8617231)
    end
  end

  describe "#graphviz_label" do
    let(:round_well) { described_class.new(4.999999999999999) }
    let(:without_label) { described_class.new(11) }
    let(:with_label) { described_class.new(42, label: 'wl' ) }
    let(:with_grad) do
      x = described_class.new(8, label: 'wg' )
      x.grad = 12.0
      x
    end

    it "rounds properly" do
      expect(round_well.graphviz_label).to eq("data: 5.0000 | grad: 0.0000")
    end

    it "doesn't have label" do
      expect(without_label.graphviz_label).to eq("data: 11.0000 | grad: 0.0000")
    end

    it "does have label" do
      expect(with_label.graphviz_label).to eq("wl | data: 42.0000 | grad: 0.0000")
    end

    it "does have a gradient" do
      expect(with_grad.graphviz_label).to eq("wg | data: 8.0000 | grad: 12.0000")
    end
  end

  describe "#topological_sort" do
    let(:a) { described_class.new(4.0, label: "a") }
    let(:b) { described_class.new(-2.0, label: "b") }
    let(:c) { described_class.new(3.0, label: "c")}
    let(:d) { x = a * b ; x.label = 'd' ; x }
    let(:e) { x = d + c ; x.label = 'e' ; x }

    it "gives back the leaf node" do
      expect(c.topological_sort).to eq([c])
    end

    it "sorts a full graph properly" do
      expect(e.topological_sort.map(&:label)).to eq(%w[a b d c e])
    end
  end

  describe '#backward' do

  end

  context "in expressions" do
    let(:a) { described_class.new(2, label: "a") }
    let(:b) { described_class.new(-3, label: "b") }
    let(:c) { described_class.new(10, label: "c") }
    let(:d) { a * b + c }

    it "the type is Value" do
      expect(d).to be_a(described_class)
    end

    it "can do the right operations" do
      expect(d.data).to eq(4.0)
    end

    it "has the right children" do
      expect(d.children).to include(c)
      expect(d.children.size).to eq(2)
    end

    it "has the right operation" do
      expect(d.op.name).to eq("+")
    end
  end

  context "doing backward propagation" do
    let(:a) { described_class.new(2, label: "a") }
    let(:b) { described_class.new(-3, label: "b") }

    describe "+" do
      subject { a + b }

      it "computes f'(x) properly" do
        subject.grad = 8.0
        subject.backward.call
        a.backward.call
        b.backward.call

        expect(subject.grad).to eq(8.0)
        expect(a.grad).to eq(8.0)
        expect(b.grad).to eq(8.0)
      end
    end

    describe "*" do
      subject { a * b }

      it "computes f'(x) properly" do
        subject.grad = 1.0
        subject.backward.call
        a.backward.call
        b.backward.call

        expect(subject.grad).to eq(1.0)
        expect(a.grad).to eq(-3.0)
        expect(b.grad).to eq(2.0)
      end
    end

    context "compound expression" do
      let(:c) { described_class.new(3, label: "c") }
      let(:ab) { a * b }
      subject { ab + c }

      it "computes f'(x) manually" do
        subject.grad = 1.0
        subject.backward.call
        ab.backward.call
        c.backward.call
        b.backward.call
        a.backward.call

        expect(subject.data).to eq(-3.0)
        expect(ab.grad).to eq(1.0)
        expect(c.grad).to eq(1.0)
        expect(a.grad).to eq(-3.0)
        expect(b.grad).to eq(2.0)
      end

      describe '#backpropagate!' do
        it "computes f'(x) automatically" do
          subject.backpropagate!

          expect(subject.data).to eq(-3.0)
          expect(ab.grad).to eq(1.0)
          expect(c.grad).to eq(1.0)
          expect(a.grad).to eq(-3.0)
          expect(b.grad).to eq(2.0)
        end
      end
    end
  end
end
