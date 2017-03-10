require "spec_helper"
require "quaternion_c2/classification"

RSpec.describe Quaternion do
	let(:num) { Quaternion.send(:new, 0, 0) }

	describe "#integer?" do
		subject { num.integer? }
		it { is_expected.to be false }
	end

	describe "#real?" do
		subject { num.real? }
		it { is_expected.to be false }
	end

	describe "#complex?" do
		subject { num.complex? }
		it { is_expected.to be false }
	end
end

RSpec.describe Complex do
	let(:num) { Complex(0, 0) }

	describe "#integer?" do
		subject { num.integer? }
		it { is_expected.to be false }
	end

	describe "#real?" do
		subject { num.real? }
		it { is_expected.to be false }
	end

	describe "#complex?" do
		subject { num.complex? }
		it { is_expected.to be true }
	end
end

RSpec.describe Float do
	let(:num) { 0.0 }

	describe "#integer?" do
		subject { num.integer? }
		it { is_expected.to be false }
	end

	describe "#real?" do
		subject { num.real? }
		it { is_expected.to be true }
	end

	describe "#complex?" do
		subject { num.complex? }
		it { is_expected.to be true }
	end
end
