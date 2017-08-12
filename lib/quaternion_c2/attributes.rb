require_relative 'unary'
require_relative 'equality'

class Quaternion
	# defined by Numeric:
	# * zero?    #=> self == 0
	# * nonzero? #=> zero? ? nil : self

	defined_methods = public_instance_methods

	if defined_methods.include?(:finite?)
		##
		# Returns true if its magnitude is finite, oterwise returns false.
		#
		# @return [Boolean]
		#
		def finite?
			abs.finite?
		end
	end

	if defined_methods.include?(:infinite?)
		##
		# Returns values corresponding to the value of its magnitude.
		#
		# @return [nil] if finite.
		# @return [+1]  if positive infinity.
		#
		def infinite?
			abs.infinite?
		end
	end

	undef positive? if defined_methods.include?(:positive?)
	undef negative? if defined_methods.include?(:negative?)
end
