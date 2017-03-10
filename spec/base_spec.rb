require "spec_helper"
require "quaternion_c2/base"

RSpec.describe Quaternion do
	describe ".new" do
		it "is a private class method" do
			expect { Quaternion.new(0, 0) }.to raise_error NoMethodError, /private method/
		end
	end
end
