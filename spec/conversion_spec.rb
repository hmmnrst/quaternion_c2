require "spec_helper"
require "quaternion_c2/conversion"
require "quaternion_c2/equality" # define Quaternion#==

RSpec::Matchers.define :simeq do |num2|
	match do |num1|
		eps = Float::EPSILON * 10
		(num1 - num2).abs2 <= eps.abs2 * num1.abs2 * num2.abs2
	end
end

RSpec.describe Quaternion do
	describe ".rect" do
		context "when both a and b are specified" do
			let(:a) { Complex(1, 2) }
			let(:b) { Complex(3, 4) }

			it "is equal to a+bj" do
				expect(Quaternion.rect(a, b)).to eq Quaternion.send(:new, a, b)
			end
		end

		context "when only a is specified" do
			let(:a) { Complex(1, 2) }

			it "is equal to a" do
				expect(Quaternion.rect(a)).to eq a
			end

			it "is a Quaternion" do
				expect(Quaternion.rect(a)).to be_kind_of Quaternion
			end
		end

		context "when a quaternion is specified" do
			let(:a) { Quaternion.rect(1) }

			it "should raise error" do
				expect { Quaternion.rect(a) }.to raise_error TypeError, /not a complex/
			end
		end
	end

	describe ".hrect" do
		context "when all of w, x, y, and z are specified" do
			let(:w) { 1 }
			let(:x) { 2 }
			let(:y) { 3 }
			let(:z) { 4 }

			it "is equal to w+xi+yj+zk" do
				a = Complex(w, x)
				b = Complex(y, z)
				expect(Quaternion.hrect(w, x, y, z)).to eq Quaternion.send(:new, a, b)
			end
		end

		context "when only w is specified" do
			let(:w) { 1 }

			it "is equal to w" do
				expect(Quaternion.hrect(w)).to eq w
			end

			it "is a Quaternion" do
				expect(Quaternion.hrect(w)).to be_kind_of Quaternion
			end
		end

		context "when a complex is specified" do
			let(:w) { Complex(1) }

			it "should raise error" do
				skip if (Complex.rect(Complex.rect(1)) rescue nil) # Ruby >= 2.7
				expect { Quaternion.hrect(w) }.to raise_error TypeError, /not a real/
			end
		end
	end

	describe ".polar" do
		context "when all of r, theta, and axis are specified" do
			let(:r)     { 1 }
			let(:theta) { Math::PI / 6 }
			let(:axis)  { Vector[1, 2, 2] }

			it "returns a quaternion: r * exp(theta * axis)" do
				result = Quaternion.hrect(0, *axis.normalize)
				expect(Quaternion.polar(r, theta, axis)).to simeq result
			end

			context "when axis has no length" do
				let(:r)     { -1 }
				let(:theta) { Math::PI }
				let(:axis)  { [0, 0, 0] }

				it "returns a quaternion: r" do
					result = Quaternion.hrect(r) * 1.0
					expect(Quaternion.polar(r, theta, axis)).to eq result
				end
			end
		end

		context "when only r and theta are specified" do
			let(:r)     { 1 }
			let(:theta) { 2 }

			it "is equal to Complex.polar" do
				expect(Quaternion.polar(r, theta)).to eq Complex.polar(r, theta)
			end

			it "is a Quaternion" do
				expect(Quaternion.polar(r, theta)).to be_kind_of Quaternion
			end
		end

		context "when only r is specified" do
			let(:r) { -1 }

			it "is equal to r" do
				expect(Quaternion.polar(r)).to eq r
			end

			it "is a Quaternion" do
				expect(Quaternion.polar(r)).to be_kind_of Quaternion
			end
		end
	end

	describe "#rect" do
		it "returns a pair of complex numbers" do
			num = Quaternion.rect(1, 0.0)
			expect(num.rect).to eql [Complex(1, 0), Complex(0.0, 0)]
		end
	end

	describe "#hrect" do
		it "returns four real numbers" do
			num = Quaternion.hrect(1, 2, Rational(3, 4), 5.6)
			expect(num.hrect).to eql [1, 2, Rational(3, 4), 5.6]
		end
	end

	describe "#real" do
		it "returns a real component" do
			num = Quaternion.hrect(1, 2, Rational(3, 4), 5.6)
			expect(num.real).to eql 1
		end
	end

	describe "#imag" do
		it "returns three imaginary components as a vector" do
			num = Quaternion.hrect(1, 2, Rational(3, 4), 5.6)
			expect(num.imag).to eql Vector[2, Rational(3, 4), 5.6]
		end
	end

	describe "#arg" do
		it "returns an argument (angle) in radians" do
			num = Quaternion.rect(-Complex::I)
			expect(num.arg).to eq (Math::PI / 2)
		end

		context "when a quaternion is equal to a negative real" do
			it "returns Math::PI" do
				num = Quaternion.rect(-1)
				expect(num.arg).to eq Math::PI
			end
		end

		context "when a quaternion is 0" do
			it "is equal to Complex#arg" do
				num = Quaternion.rect(0)
				expect(num.arg).to eq Complex(0).arg
			end
		end
	end

	describe "#axis" do
		it "returns a 3-D vector" do
			num = Quaternion.hrect(1, 2, 3, 4)
			expect(num.axis).to eq num.imag.normalize
		end

		context "when a quaternion is equal to a real" do
			it "returns Vector[1, 0, 0]" do
				num = Quaternion.rect(1)
				expect(num.axis).to eq Vector[1, 0, 0]
			end
		end

		context "when a quaternion is equal to a real and imag[0] is -0.0" do
			it "returns Vector[-1, 0, 0]" do
				num = Quaternion.hrect(1, -0.0)
				expect(num.axis).to eq Vector[-1, 0, 0]
			end
		end
	end
end

RSpec.describe Kernel do
	describe ".Quaternion" do
		it "is a module_function" do
			expect(Kernel.private_instance_methods  ).to     include :Quaternion
			expect(Kernel.protected_instance_methods).not_to include :Quaternion
			expect(Kernel.public_instance_methods   ).not_to include :Quaternion
			expect(Kernel.private_methods  ).not_to include :Quaternion
			expect(Kernel.protected_methods).not_to include :Quaternion
			expect(Kernel.public_methods   ).to     include :Quaternion
		end

		context "with one number" do
			it "returns a quaternion" do
				expect(Quaternion(Complex::I)).to eql Quaternion.hrect(0, 1, 0, 0)
			end
		end

		context "with two numbers" do
			it "returns a quaternion" do
				n1 = Quaternion.hrect(1, 2, 0, 0)
				n2 = Quaternion.hrect(0, 0, 3, 4)
				expect(Quaternion(n1, n2)).to eql Quaternion.hrect(-2, -2, 0, 0)
			end
		end

		context "with scalar and vector" do
			it "returns a quaternion" do
				s = 1
				v = [2, 3, 4]
				expect(Quaternion(s, v)).to eql Quaternion.hrect(1, 2, 3, 4)
			end
		end

		context "with three numbers" do
			it "returns a quaternion" do
				expect(Quaternion(1, 2, 3)).to eql Quaternion.hrect(1, 2, 3, 0)
			end
		end

		context "with four numbers" do
			it "returns a quaternion" do
				expect(Quaternion('1', 'i', 'j', 'k')).to eql Quaternion.hrect(-2)
			end
		end
	end
end
