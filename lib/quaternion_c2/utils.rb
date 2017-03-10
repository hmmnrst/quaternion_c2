require_relative 'base'
require_relative 'classification'
require_relative 'unary'
require_relative 'arithmetic'
require_relative 'conversion'

class Quaternion
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
