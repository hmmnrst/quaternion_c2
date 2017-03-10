require "spec_helper"
require "quaternion_c2/to_type"
require "quaternion_c2/equality" # define #eql?

RSpec.describe Quaternion do
	describe "#to_q" do
		it "returns self" do
			num = Quaternion.send(:new, 1, 0)
			expect(num.to_q).to equal num
		end
	end

	describe "#to_c" do
		context "when @b is an exact zero" do
			it "returns @a" do
				a = Complex(1, 2.0)
				b = Complex(0, Rational(0))
				num = Quaternion.send(:new, a, b)
				expect(num.to_c).to eql a
			end
		end

		context "when @b is not an exact zero" do
			it "raises error" do
				a = Complex(1, 2.0)
				b = Complex(0, 0.0)
				num = Quaternion.send(:new, a, b)
				expect { num.to_c }.to raise_error RangeError
			end
		end
	end

	describe "#to_f" do
		context "when imaginary part is an exact zero" do
			it "returns real part as a float" do
				a = Complex(1, 0)
				b = Complex(0, Rational(0))
				num = Quaternion.send(:new, a, b)
				expect(num.to_f).to eql 1.0
			end
		end

		context "when imaginary part is not an exact zero" do
			it "raises error" do
				a = Complex(1, 0)
				b = Complex(0, 0.0)
				num = Quaternion.send(:new, a, b)
				expect { num.to_f }.to raise_error RangeError
			end
		end
	end

=begin
	describe "#to_s" do
		it "returns a string" do
			a = Complex(-1, 2) / 5
			b = Complex(-3, 4.0) / 5
			num = Quaternion.send(:new, a, b)
			expect(num.to_s).to eq "-1/5+2/5i-3/5j+0.8k"
		end
	end

	describe "#inspect" do
		it "returns a string" do
			a = Complex(-1, 2) / 5
			b = Complex(-3, 4.0) / 5
			num = Quaternion.send(:new, a, b)
			expect(num.inspect).to eq "((-1/5)+(2/5)*i-(3/5)*j+0.8k)"
		end
	end
=end
end

RSpec.describe Numeric do
	describe "#to_q" do
		it "returns a quaternion" do
			num_i = 2 ** 1024
			num_r = Rational(22, 7)
			num_f = -0.0
			num_c = Complex::I
			expect(num_i.to_q).to eql Quaternion.send(:new, num_i, 0)
			expect(num_r.to_q).to eql Quaternion.send(:new, num_r, 0)
			expect(num_f.to_q).to eql Quaternion.send(:new, num_f, 0)
			expect(num_c.to_q).to eql Quaternion.send(:new, num_c, 0)
		end
	end
end

RSpec.describe String do
	describe "#to_q" do
		it "returns a quaternion" do
			str = "-1/5+2/5i-3/5j+0.8k"
			a = Complex(-1, 2) / 5
			b = Complex(-3, 4.0) / 5
			num = Quaternion.send(:new, a, b)
			expect(str.to_q).to eql num
		end
	end
end

RSpec.describe NilClass do
	describe "#to_q" do
		it "returns a quaternion" do
			expect(nil.to_q).to eql Quaternion.send(:new, 0, 0)
		end
	end
end
