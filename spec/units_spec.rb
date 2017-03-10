require "spec_helper"
require "quaternion_c2/units"
require "quaternion_c2/equality" # define #eql?

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

