require_relative 'base'

#
# Unary operations
#

class Quaternion
	# defined by Numeric:
	# * +@ #=> self
	# * -@ #=> 0 - self

	def conj
		__new__(@a.conj, -@b)
	end
	alias conjugate conj

	def abs2
		@a.abs2 + @b.abs2
	end

	def abs
		a_abs = @a.abs
		b_abs = @b.abs
		if    __exact_zero__(a_abs)
			b_abs
		elsif __exact_zero__(b_abs)
			a_abs
		else
			Math.hypot(a_abs, b_abs)
		end
	end
	alias magnitude abs

	private

	def __exact_zero__(x)
		1 / x
	rescue ZeroDivisionError
		true
	else
		false
	end

	def __reciprocal__
		d2 = abs2
		__new__(@a.conj.quo(d2), @b.quo(-d2))
	end
end
