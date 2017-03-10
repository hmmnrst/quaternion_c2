require_relative 'base'

#
# Fundamental quaternion units
#

class Quaternion
	i = Complex::I
	I = new(i, 0)
	J = new(0, 1)
	K = new(0, i)
end

#
# Convert to an imaginary part
#

class Numeric
	# defined:
	# * #i #=> Complex.rect(0, self)

	def j
		Quaternion.send(:new, 0, self)
	end

	def k
		Quaternion.send(:new, 0, self.i)
	end
end

class Complex
	# undefined:
	# * #i

	undef k
end

class Quaternion
	undef i, j, k
end
