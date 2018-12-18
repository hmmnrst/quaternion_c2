require "spec_helper"
require "quaternion_c2/units"
require "quaternion_c2/equality" # define #eql?

RSpec.describe Quaternion do
	let(:c_0) { Complex(0, 0) }
	let(:c_1) { Complex(1, 0) }
	let(:c_i) { Complex(0, 1) }

	describe "constants" do
		it "are 3 imaginary units" do
			expect(Quaternion.constants).to contain_exactly(*Complex.constants, :J, :K)
		end
	end

	describe "::I" do
		it { expect(Quaternion::I).to eql Quaternion.send(:new, c_i, c_0) }
	end

	describe "::J" do
		it { expect(Quaternion::J).to eql Quaternion.send(:new, c_0, c_1) }
	end

	describe "::K" do
		it { expect(Quaternion::K).to eql Quaternion.send(:new, c_0, c_i) }
	end
end

RSpec.describe Quaternion do
	let(:num) { Quaternion.send(:new, 0, 0) }

	describe "#i" do
		it "is not defined" do
			expect { num.i }.to raise_error NoMethodError
		end
	end

	describe "#j" do
		it "is not defined" do
			expect { num.j }.to raise_error NoMethodError
		end
	end

	describe "#k" do
		it "is not defined" do
			expect { num.k }.to raise_error NoMethodError
		end
	end
end

RSpec.describe Complex do
	let(:num) { Complex::I }

	describe "#i" do
		it "is not defined" do
			expect { num.i }.to raise_error NoMethodError
		end
	end

	describe "#j" do
		it "returns num * j" do
			expect(num.j).to eql Quaternion.send(:new, 0, num)
		end
	end

	describe "#k" do
		it "is not defined" do
			expect { num.k }.to raise_error NoMethodError
		end
	end
end

RSpec.describe Numeric do
	let(:num) { 1 }

	describe "#i" do
		it "returns num * i" do
			expect(num.i).to eql Complex::I
		end
	end

	describe "#j" do
		it "returns num * j" do
			expect(num.j).to eql Quaternion::J
		end
	end

	describe "#k" do
		it "returns num * k" do
			expect(num.k).to eql Quaternion::K
		end
	end
end

