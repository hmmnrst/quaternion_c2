require_relative 'base'
require_relative 'classification'
require_relative 'unary'
require_relative 'arithmetic'
require_relative 'conversion'

class Quaternion
	def **(index)
		unless index.kind_of?(Numeric)
			num1, num2 = index.coerce(self)
			return num1 ** num2
		end

		if __exact_zero__(index)
			return __new__(1, 0)
		end

		# complex -> real
		# (only if the imaginary part is exactly zero)
		unless index.real?
			begin
				index.to_f
			rescue
			else
				index = index.real
			end
		end

		# rational -> integer
		if index.kind_of?(Rational) && index.denominator == 1
			index = index.numerator
		end

		# calc and return
		if index.integer?
			# exponentiation by squaring
			x = (index >= 0) ? self : __reciprocal__
			n = index.abs

			z = __new__(1, 0)
			while true
				z *= x if n.odd?
				n >>= 1
				return z if n.zero?
				x *= x
			end
		elsif index.real?
			r, theta, vector = polar
			Quaternion.polar(r ** index, theta * index, vector)
		elsif index.complex? || index.kind_of?(Quaternion)
			# assume that log(self) commutes with index under multiplication
			r, theta, vector = polar
			q = Quaternion.hrect(Math.log(r), *(theta * vector))
			q *= index
			Quaternion.polar(Math.exp(q.real), 1, q.imag)
		else
			num1, num2 = index.coerce(self)
			num1 ** num2
		end
	end

	def denominator
		ad = @a.denominator
		bd = @b.denominator
		ad.lcm(bd)
	end

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
