require_relative 'base'

#
# Number system classification
# (N <) Z < Q < R < C < H (< ...)
#
# * quaternion?  : [H] Quaternion (*undefined*)
# * && complex?  : [C] Complex
# * && real?     : [R] Float, BigDecimal, Numeric
# * && rational? : [Q] Rational (*undefined*)
# * && integer?  : [Z] Fixnum, Bignum, Integer
#

class Numeric
	# defined:
	# * integer? #=> false
	# * real?    #=> true

	def complex?
		true
	end
end

class Quaternion
	def real?
		false
	end

	def complex?
		false
	end
end
