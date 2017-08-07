require_relative 'base'
require_relative 'classification'
require_relative 'unary'

class Quaternion
	##
	# Basic arithmetic operators (#+, #-, #*, #/)
	# and related methods
	#

	##
	# Performs addition.
	#
	# @param other [Numeric]
	# @return [Quaternion]
	#
	def +(other)
		if other.kind_of?(Quaternion)
			__new__(@a + other.a, @b + other.b)
		elsif other.kind_of?(Numeric) && other.complex?
			__new__(@a + other, @b)
		else
			n1, n2 = other.coerce(self)
			n1 + n2
		end
	end

	##
	# Performs subtraction.
	#
	# @param other [Numeric]
	# @return [Quaternion]
	#
	def -(other)
		if other.kind_of?(Quaternion)
			__new__(@a - other.a, @b - other.b)
		elsif other.kind_of?(Numeric) && other.complex?
			__new__(@a - other, @b)
		else
			n1, n2 = other.coerce(self)
			n1 - n2
		end
	end

	##
	# Performs multiplication.
	#
	# @param other [Numeric]
	# @return [Quaternion]
	#
	def *(other)
		if other.kind_of?(Quaternion)
			_a = other.a
			_b = other.b
			__new__(@a * _a - _b.conj * @b, _b * @a + @b * _a.conj)
		elsif other.kind_of?(Numeric) && other.complex?
			__new__(@a * other, @b * other.conj)
		else
			n1, n2 = other.coerce(self)
			n1 * n2
		end
	end

	##
	# @!method quo(other)
	#
	# Performs division.
	#
	# @param other [Numeric]
	# @return [Quaternion]
	# @raise [ZeroDivisionError] if +other+ is exactly zero.
	#

	##
	# @!method fdiv(other)
	#
	# Performs division as each part is a float, never returns a float.
	#
	# @param other [Numeric]
	# @return [Quaternion]
	#

	[:quo, :fdiv].each do |sym|
		define_method(sym) do |other|
			if other.kind_of?(Quaternion)
				self * other.conj.send(sym, other.abs2)
			elsif other.kind_of?(Numeric) && other.complex?
				__new__(@a.send(sym, other), @b.send(sym, other.conj))
			else
				n1, n2 = other.coerce(self)
				n1.send(sym, n2)
			end
		end
	end
	alias / quo
	undef div, %, modulo, remainder, divmod

	##
	# Conversion
	#

	##
	# Performs type conversion.
	#
	# @param other [Numeric]
	# @return [[Quaternion, self]]
	# @raise [TypeError]
	#
	def coerce(other)
		if other.kind_of?(Quaternion)
			[other, self]
		elsif other.kind_of?(Numeric) && other.complex?
			[__new__(other, 0), self]
		else
			raise TypeError,
			      "#{other.class} can't be coerced into #{self.class}"
		end
	end
end
