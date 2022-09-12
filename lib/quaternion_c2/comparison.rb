require_relative 'base'
require_relative 'arithmetic' # define Quaternion#coerce

if Complex.public_method_defined?(:<=>)
	class Quaternion
		##
		# Compare values if both are real numbers.
		#
		# @param other [Object]
		# @return [-1, 0, 1, or nil]
		#
		def <=>(other)
			if other.kind_of?(Quaternion)
				(@b == 0 && other.b == 0) ? (@a <=> other.a) : nil
			elsif other.kind_of?(Numeric) && other.complex?
				(@b == 0) ? (@a <=> other) : nil
			elsif other.respond_to?(:coerce)
				n1, n2 = other.coerce(self)
				n1 <=> n2
			else
				nil
			end
		end
	end

	# Check whether built-in Complex#<=> uses type coercions.
	if (Complex.rect(0, 0) <=> Quaternion.send(:new, 0, 0)).nil?
		warn "Redefine Complex#<=> to allow type coercions."

		class Complex
			##
			# Compare values if both are real numbers.
			#
			# @param other [Object]
			# @return [-1, 0, 1, or nil]
			#
			def <=>(other)
				if other.kind_of?(Complex)
					(imag == 0 && other.imag == 0) ? (real <=> other.real) : nil
				elsif other.kind_of?(Numeric) && other.real?
					(imag == 0) ? (real <=> other) : nil
				elsif other.respond_to?(:coerce)
					n1, n2 = other.coerce(self)
					n1 <=> n2
				else
					nil
				end
			end
		end
	end
else
	class Quaternion
		undef <=>
	end
end
