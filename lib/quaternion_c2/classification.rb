require_relative 'base'

class Numeric
	##
	# Number system classification
	# (N <) Z < Q < R < C < H (< ...)
	#
	# * quaternion?  : [H] Quaternion (*undefined*)
	# * && complex?  : [C] Complex
	# * && real?     : [R] Float, BigDecimal, Numeric
	# * && rational? : [Q] Rational (*undefined*)
	# * && integer?  : [Z] Fixnum, Bignum, Integer
	#

	# defined:
	# * integer? #=> false
	# * real?    #=> true

	##
	# Returns true.
	#
	def complex?
		true
	end
end

class Quaternion
	# defined by Numeric:
	# * integer? #=> false

	##
	# Returns false.
	#
	def real?
		false
	end

	##
	# Returns false.
	#
	def complex?
		false
	end
end
