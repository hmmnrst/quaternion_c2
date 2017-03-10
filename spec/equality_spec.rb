require "spec_helper"
require "quaternion_c2/equality"

RSpec.describe Quaternion do
	describe "#==" do
		subject { num1 == num2 }
		let(:num1) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }

		context "when compared with an identical number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }
			it { is_expected.to be true }
		end

		context "when compared with an equivalent number" do
			let(:num2) { 1 }
			it { is_expected.to be true }
		end

		context "when compared with a different number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 1.0)) }
			it { is_expected.to be false }
		end

		context "when compared with a string" do
			let(:num2) { "1+0i+0/1j+1.0k" }
			it { is_expected.to be false }
		end
	end

	describe "#eql?" do
		subject { num1.eql?(num2) }
		let(:num1) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }

		context "when compared with an identical number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }
			it { is_expected.to be true }
		end

		context "when compared with an equivalent number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0)) }
			it { is_expected.to be false }
		end

		context "when compared with a different number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 1.0)) }
			it { is_expected.to be false }
		end

		context "when compared with a string" do
			let(:num2) { "1+0i+0/1j+1.0k" }
			it { is_expected.to be false }
		end
	end

	describe "#hash" do
		subject { num1.hash }
		let(:num1) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }

		context "when compared with an identical number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }
			it "should return a same value" do
				is_expected.to eq num2.hash
			end
		end

		context "when compared with an equivalent number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0)) }
			it "should not return a same value" do
				is_expected.not_to eq num2.hash
			end
		end

		context "when compared with a different number" do
			let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 1.0)) }
			it "should not return a same value" do
				is_expected.not_to eq num2.hash
			end
		end

		context "when compared with a string" do
			let(:num2) { "1+0i+0/1j+1.0k" }
			it "should not return a same value" do
				is_expected.not_to eq num2.hash
			end
		end
	end
end
