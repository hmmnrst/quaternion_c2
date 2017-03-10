require "spec_helper"
require "quaternion_c2/attributes"

RSpec.describe Quaternion do
	describe "#zero?" do
		subject { num.zero? }

		context "when a quaternion is zero" do
			let(:num) { Quaternion.send(:new, 0, 0.0) }
			it { is_expected.to be true }
		end

		context "when a quaternion is not zero" do
			let(:num) { Quaternion.send(:new, 0, 1) }
			it { is_expected.to be false }
		end
	end

	describe "#nonzero?" do
		subject { num.nonzero? }

		context "when a quaternion is zero" do
			let(:num) { Quaternion.send(:new, 0, 0.0) }
			it { is_expected.to be_nil }
		end

		context "when a quaternion is not zero" do
			let(:num) { Quaternion.send(:new, 0, 1) }
			it { is_expected.to equal num }
		end
	end

	describe "#finite?" do
		subject { num.finite? }

		context "when a quaternion has a big Integer and no Floats" do
			let(:num) { Quaternion.send(:new, 0, 2 ** 1024) }
			it { is_expected.to be true }
		end

		context "when a quaternion has a big Integer and a small Float" do
			let(:num) { Quaternion.send(:new, 0.0, 2 ** 1024) }
			it { is_expected.to be false }
		end

		context "when a quaternion has a big finite Float and zeros" do
			let(:num) { Quaternion.send(:new, 0, Float::MAX) }
			it { is_expected.to be true }
		end

		context "when a quaternion has big finite Floats" do
			let(:num) { Quaternion.send(:new, Float::MAX, Float::MAX) }
			it { is_expected.to be false }
		end

		context "when a quaternion has a NaN" do
			let(:num) { Quaternion.send(:new, 0, Float::NAN) }
			it { is_expected.to be false }
		end
	end if Quaternion.instance_methods.include?(:finite?)

	describe "#infinite?" do
		subject { num.infinite? }

		context "when a quaternion has a big Integer and no Floats" do
			let(:num) { Quaternion.send(:new, 0, 2 ** 1024) }
			it { is_expected.to be_nil }
		end

		context "when a quaternion has a big Integer and a small Float" do
			let(:num) { Quaternion.send(:new, 0.0, 2 ** 1024) }
			it { is_expected.to equal 1 }
		end

		context "when a quaternion has a big finite Float and zeros" do
			let(:num) { Quaternion.send(:new, 0, Float::MAX) }
			it { is_expected.to be_nil }
		end

		context "when a quaternion has big finite Floats" do
			let(:num) { Quaternion.send(:new, Float::MAX, Float::MAX) }
			it { is_expected.to equal 1 }
		end

		context "when a quaternion has a NaN" do
			let(:num) { Quaternion.send(:new, 0, Float::NAN) }
			it { is_expected.to be_nil }
		end
	end if Quaternion.instance_methods.include?(:infinite?)
end
