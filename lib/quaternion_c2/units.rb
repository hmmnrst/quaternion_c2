require_relative 'base'

class Quaternion
	##
	# Fundamental quaternion units
	#

	i = Complex::I
	I = new(i, 0)
	J = new(0, 1)
	K = new(0, i)
end

class Numeric
	##
	# Convert to an imaginary part
	#

	# defined:
	# * i #=> Complex.rect(0, self)

	##
	# Returns the corresponding imaginary number.
	# Not available for quaternions.
	#
	# @return [Quaternion] +self * Quaternion::J+
	# @raise [NoMethodError] if +self+ is not a complex.
	#
	# @example
	#   3.j             #=> (0+0i+3j+0k)
	#   Complex(3, 4).j #=> (0+0i+3j+4k)
	#
	def j
		Quaternion.send(:new, 0, self)
	end

	##
	# Returns the corresponding imaginary number.
	# Not available for complex numbers.
	#
	# @return [Quaternion] +self * Quaternion::K+
	# @raise [NoMethodError] if +self+ is not a real.
	#
	# @example
	#   4.k #=> (0+0i+0j+4k)
	#
	def k
		Quaternion.send(:new, 0, self.i)
	end
end

##
# @!parse class Complex < Numeric; end
#
class Complex
	# undefined:
	# * #i

	undef k
end

class Quaternion
	undef i, j, k
end
