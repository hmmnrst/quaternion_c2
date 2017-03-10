require "spec_helper"
require "quaternion_c2/unary"
require "quaternion_c2/equality" # define #eql?

RSpec.describe Quaternion do
	let(:num) { Quaternion.send(:new, 0, 0) }

	describe "#conj" do
		it "returns a conjugate quaternion" do
			q  = Quaternion.send(:new, Complex(1, -2), Complex(-3,  4))
			qc = Quaternion.send(:new, Complex(1,  2), Complex( 3, -4))
			expect(q.conj).to eql qc
		end
	end

	describe "#abs2" do
		it "returns |q|^2" do
			q  = Quaternion.send(:new, Complex(1, -2), Complex(-3,  4))
			expect(q.abs2).to eql 30
		end
	end

	describe "#abs" do
		it "returns an absolute value" do
			num = Quaternion.send(:new, Complex(1, 1), Complex(3, 5))
			expect(num.abs).to eql 6.0
		end

		context "when three components are 0" do
			it "returns an absolute value of the other component" do
				num = Quaternion.send(:new, Complex(0, Rational(0, 1)), Complex(0, -1))
				expect(num.abs).to eql 1
			end
		end

		context "when three components are 0.0" do
			it "returns an absolute value" do
				num = Quaternion.send(:new, Complex(0, 0.0), Complex(0, -1))
				expect(num.abs).to eql 1.0
			end
		end
	end
end
