require "spec_helper"
require "quaternion_c2/comparison"

class CoerceMock
	def coerce(other)
		[other, other]
	end
end

RSpec.describe Quaternion do
	describe "#<=>" do
		subject { num1 <=> num2 }

		context "when self is real" do
			let(:num1) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }

			context "and when compared with an equivalent number" do
				let(:num2) { 1 }
				it { is_expected.to eql 0 }
			end

			context "and when compared with a larger number" do
				let(:num2) { Complex(10, 0) }
				it { is_expected.to eql -1 }
			end

			context "and when compared with a smaller number" do
				let(:num2) { Rational(1, 2) }
				it { is_expected.to eql 1 }
			end

			context "and when compared with a complex number" do
				let(:num2) { Complex(1, 1) }
				it { is_expected.to be_nil }
			end

			context "and when compared with a quaternion" do
				let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(0, 1)) }
				it { is_expected.to be_nil }
			end

			context "and when compared with a string" do
				let(:num2) { "1+0i+0/1j+0.0k" }
				it { is_expected.to be_nil }
			end

			context "and when compared with a coercable object" do
				let(:num2) { CoerceMock.new }
				it "calls other.coerce" do
					is_expected.to eql 0
				end
			end
		end

		context "when self is not real" do
			let(:num1) { Quaternion.send(:new, Complex(0, 0), Complex(0, 1)) }

			context "and when self == other" do
				let(:num2) { Quaternion.send(:new, Complex(0.0, 0.0), Complex(0.0, 1.0)) }
				it { is_expected.to be_nil }
			end

			context "and when self != other" do
				let(:num2) { "0+0i+0j+1k" }
				it { is_expected.to be_nil }
			end

			context "and when compared with a coercable object" do
				let(:num2) { CoerceMock.new }
				it "calls other.coerce" do
					is_expected.to be_nil
				end
			end
		end
	end
end if Complex.public_method_defined?(:<=>)

RSpec.describe Complex do
	describe "#<=>" do
		subject { num1 <=> num2 }

		context "when self is real" do
			let(:num1) { Complex(1, 0.0) }

			context "and when compared with an equivalent number of Quaternion class" do
				let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(Rational(0, 1), 0.0)) }
				it { is_expected.to eql 0 }
			end

			context "and when compared with a larger number" do
				let(:num2) { Complex(10, 0) }
				it { is_expected.to eql -1 }
			end

			context "and when compared with a smaller number" do
				let(:num2) { Rational(1, 2) }
				it { is_expected.to eql 1 }
			end

			context "and when compared with a complex number" do
				let(:num2) { Complex(1, 1) }
				it { is_expected.to be_nil }
			end

			context "and when compared with a quaternion" do
				let(:num2) { Quaternion.send(:new, Complex(1, 0), Complex(0, 1)) }
				it { is_expected.to be_nil }
			end

			context "and when compared with a string" do
				let(:num2) { "1+0.0i" }
				it { is_expected.to be_nil }
			end

			context "and when compared with a coercable object" do
				let(:num2) { CoerceMock.new }
				it "calls other.coerce" do
					is_expected.to eql 0
				end
			end
		end

		context "when self is not real" do
			let(:num1) { Complex(0, 1) }

			context "and when self == other" do
				let(:num2) { Complex(0.0, 1.0) }
				it { is_expected.to be_nil }
			end

			context "and when self != other" do
				let(:num2) { "0+1i" }
				it { is_expected.to be_nil }
			end

			context "and when compared with a coercable object" do
				let(:num2) { CoerceMock.new }
				it "calls other.coerce" do
					is_expected.to be_nil
				end
			end
		end
	end
end if Complex.public_method_defined?(:<=>)
