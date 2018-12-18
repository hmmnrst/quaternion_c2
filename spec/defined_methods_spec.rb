require "spec_helper"
require "quaternion_c2"

q_all = Quaternion.public_instance_methods(true)
q_def = Quaternion.public_instance_methods(false)
c_all = Complex.public_instance_methods(true)
c_def = Complex.public_instance_methods(false)
n_all = Numeric.public_instance_methods(true)

qc_def = Quaternion.methods(false)
cc_def = Complex.methods(false)

# extra methods for Quaternion
q_ext = [:axis, :hrect, :hyperrectangular, :scalar, :vector]
qc_ext = [:hrect, :hyperrectangular]

# optional methods (which may be overridden to improve performance)
q_opt = [:+@, :-@,            :integer?,     :nonzero?, :to_int,        :zero?]
c_opt = [:+@, :-@, :complex?, :integer?, :j, :nonzero?, :to_int, :to_q, :zero?]

RSpec.describe Quaternion do
	describe "public instance methods" do
		it "are almost same to those for Complex" do
			expect(q_all - c_all).to contain_exactly(*q_ext)
			expect(c_all - q_all).to contain_exactly(:j)
		end
	end

	describe "inherited instance methods" do
		it "are almost same to those for Complex" do
			q_inherit = q_all - q_def - q_opt
			c_inherit = c_all - c_def - c_opt
			expect(q_inherit - c_inherit).to contain_exactly()
			expect(c_inherit - q_inherit).to contain_exactly()
		end
	end

	describe "overridden instance methods" do
		it "are almost same to those for Complex" do
			q_override = n_all & q_def - q_opt
			c_override = n_all & c_def - c_opt
			expect(q_override - c_override).to contain_exactly(:complex?, :to_q)
			expect(c_override - q_override).to contain_exactly()
		end
	end

	describe "undefined instance methods" do
		it "are almost same to those for Complex" do
			q_undef = n_all - q_all
			c_undef = n_all - c_all
			expect(q_undef - c_undef).to contain_exactly(:j)
			expect(c_undef - q_undef).to contain_exactly()
		end
	end

	describe "public class methods" do
		it "are almost same to those for Complex" do
			expect(qc_def - cc_def).to contain_exactly(*qc_ext)
			expect(cc_def - qc_def).to contain_exactly()
		end
	end
end
