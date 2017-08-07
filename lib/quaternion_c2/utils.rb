require_relative 'base'
require_relative 'classification'
require_relative 'unary'
require_relative 'arithmetic'
require_relative 'conversion'

class Quaternion
	##
	# Performs exponentiation.
	#
	# @param index [Numeric]
	# @return [Quaternion]
	#
	# @example
	#   Quaternion(1, 1, 1, 1) ** 6 #=> (64+0i+0j+0k)
	#   Math::E.to_q ** Quaternion(Math.log(2), [Math::PI/3 / Math.sqrt(3)] * 3)
	#   #=> (1.0000000000000002+1.0i+1.0j+1.0k)
	#
	def **(index)
		if index.kind_of?(Numeric)
			if __exact_zero__(index)
				return __new__(1, 0)
			end

			# complex -> real
			begin
				index.to_f
			rescue
			else
				index = index.real
			end

			# rational -> integer
			if index.kind_of?(Rational) && index.denominator == 1
				index = index.numerator
			end

			if index.integer?
				# binary method
				x = (index >= 0) ? self : 1 / self
				n = index.abs

				z = __new__(1, 0)
				while true
					n, i = n.divmod(2)
					z *= x if i == 1
					return z if n == 0
					x *= x
				end
			elsif index.real?
				r, theta, vector = polar
				return Quaternion.polar(r ** index, theta * index, vector)
			elsif index.complex? || index.kind_of?(Quaternion)
				r, theta, vector = polar
				q = Math.log(r) + Quaternion.hrect(0, *(theta * vector))
				q *= index
				return Quaternion.polar(Math.exp(q.real), 1, q.imag)
			end
		end

		num1, num2 = other.coerce(self)
		num1 ** num2
	end

	##
	# Returns the denominator (lcm of all components' denominators).
	# @see numerator
	#
	# @return [Integer]
	#
	def denominator
		ad = @a.denominator
		bd = @b.denominator
		ad.lcm(bd)
	end

	##
	# Returns the numerator.
	#
	#   1   1    1    3     4-6i-12j+9k <- numerator
	#   - - -i - -j + -k -> -----------
	#   3   2    1    4         12      <- denominator
	#
	# @return [Quaternion]
	#
	# @example
	#   q = Quaternion('1/3-1/2i-j+3/4k') #=> ((1/3)-(1/2)*i-1j+(3/4)*k)
	#   n = q.numerator                   #=> (4-6i-12j+9k)
	#   d = q.denominator                 #=> 12
	#   n / d == q                        #=> true
	#
	def numerator
		an = @a.numerator
		bn = @b.numerator
		ad = @a.denominator
		bd = @b.denominator
		abd = ad.lcm(bd)
		__new__(an * (abd / ad), bn * (abd / bd))
	end

	undef step
	undef ceil, floor, round, truncate
end
