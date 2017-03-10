require_relative 'base'
require_relative 'classification'

class Quaternion
	undef <=>
	undef_method(*Comparable.instance_methods)

	def ==(other)
		if other.kind_of?(Quaternion)
			@a == other.a && @b == other.b
		elsif other.kind_of?(Numeric) && other.complex?
			@a == other && @b == 0
		else
			other == self
		end
	end

	def eql?(other)
		if other.kind_of?(Quaternion)
			@a.eql?(other.a) && @b.eql?(other.b)
		else
			false
		end
	end

	# q1.eql?(q2) => q1.hash == q2.hash
	def hash
		[@a, @b].hash
	end
end
