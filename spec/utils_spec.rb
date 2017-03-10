require "spec_helper"
require "quaternion_c2/utils"
require "quaternion_c2/arithmetic"
require "quaternion_c2/equality"

RSpec.describe Quaternion do
	describe "#**" do
		subject { base ** index }

		context "when index is an integer" do
			let(:base) { Quaternion.hrect(1, 1, -1, -1) }
			let(:index) { 6 }

			it { is_expected.to eql Quaternion.hrect(64, 0, 0, 0) }
		end

		context "when index is a quaternion" do
			let(:base)  { Quaternion::J }
			let(:index) { Quaternion::J }

			it { is_expected.to eq Complex::I ** Complex::I }
		end
	end

	describe "#denominator" do
		let(:num) { Quaternion.rect(Complex(2, -3) / 6, Complex(-1, Rational(3, 4))) }

		it "returns a positive integer" do
			expect(num.denominator).to be_kind_of Integer
			expect(num.denominator).to be > 0
		end
	end

	describe "#numerator" do
		let(:num) { Quaternion.rect(Complex(2, -3) / 6, Complex(-1, Rational(3, 4))) }

		it "returns a quaternion whose coefficients are all integers" do
			expect(num.numerator).to be_kind_of Quaternion
			expect(num.numerator.hrect).to all be_an Integer
		end

		it "returns the numerator of an irreducible fraction" do
			numerator   = num.numerator
			denominator = num.denominator
			expect(numerator / denominator).to eq num
			expect(numerator.hrect.inject(denominator, :gcd)).to eq 1
		end
	end
end
