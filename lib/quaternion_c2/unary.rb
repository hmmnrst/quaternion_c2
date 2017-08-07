require_relative 'base'

class Quaternion
	##
	# Unary operations
	#

	# defined by Numeric:
	# * +@ #=> self
	# * -@ #=> 0 - self

	##
	# Returns its conjugate.
	#
	# @return [Quaternion]
	#
	# @example
	#   Quaternion(1, 2, 3, 4).conj #=> (1-2i-3j-4k)
	#
	def conj
		__new__(@a.conj, -@b)
	end
	alias conjugate conj

	##
	# Returns square of the absolute value.
	#
	# @return [Real]
	#
	# @example
	#   Quaternion(-1, 1, -1, 1).abs2 #=> 4
	#
	def abs2
		@a.abs2 + @b.abs2
	end

	##
	# Returns the absolute part of its polar form.
	#
	# @return [Real]
	#
	# @example
	#   Quaternion(-1, 1, -1, 1).abs #=> 2.0
	#
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
end
