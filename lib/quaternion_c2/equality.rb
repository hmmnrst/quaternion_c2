require_relative 'base'
require_relative 'classification'

class Quaternion
	undef <=>
	undef_method(*Comparable.instance_methods)

	##
	# Returns true if it equals to the other numerically.
	#
	# @param other [Object]
	# @return [Boolean]
	#
	def ==(other)
		if other.kind_of?(Quaternion)
			@a == other.a && @b == other.b
		elsif other.kind_of?(Numeric) && other.complex?
			@a == other && @b == 0
		else
			other == self
		end
	end

	##
	# Returns true if two quaternions have same reals.
	#
	# @param other [Object]
	# @return [Boolean]
	#
	def eql?(other)
		if other.kind_of?(Quaternion)
			@a.eql?(other.a) && @b.eql?(other.b)
		else
			false
		end
	end

	##
	# Returns a hash.
	#
	# @return [Integer]
	#
	def hash
		# q1.eql?(q2) -> q1.hash == q2.hash
		[@a, @b].hash
	end
end
