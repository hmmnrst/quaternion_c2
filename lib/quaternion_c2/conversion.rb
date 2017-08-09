require_relative 'base'
require_relative 'classification'
require_relative 'unary'
require_relative 'units'
require_relative 'arithmetic'
require_relative 'to_type'

require 'matrix'

class Quaternion
	#
	# Constructors
	#

	class << self
		def rect(a, b = 0)
			unless [a, b].all? { |c| c.kind_of?(Numeric) && c.complex? }
				raise TypeError, 'not a complex'
			end
			new(a, b)
		end
		alias rectangular rect

		def hrect(w, x = 0, y = 0, z = 0)
			a = Complex.rect(w, x)
			b = Complex.rect(y, z)
			new(a, b)
		end
		alias hyperrectangular hrect

		# Quaternion.polar(r) == r
		# Quaternion.polar(r, theta) == Complex.polar(r, theta)
		def polar(r, theta = 0, vector = Vector[1, 0, 0])
			unless vector.kind_of?(Enumerable) && vector.size == 3
				raise TypeError, 'not a 3-D vector'
			end
			unless [r, theta, *vector].all? { |a| a.kind_of?(Numeric) && a.real? }
				raise TypeError, 'not a real'
			end

			vector = Vector[*vector] unless vector.kind_of?(Vector)
			norm = vector.norm
			theta *= norm

			r_cos = r * Math.cos(theta)
			r_sin = r * Math.sin(theta)
			r_sin /= norm if norm > 0
			hrect(r_cos, *(r_sin * vector))
		end
	end

	#
	# Accessors
	#

	def rect
		[@a, @b]
	end
	alias rectangular rect

	def hrect
		rect.flat_map(&:rect)
	end
	alias hyperrectangular hrect

	def real
		@a.real
	end
	alias scalar real

	def imag
		Vector[*hrect.drop(1)]
	end
	alias imaginary imag
	alias vector imag

	# defined in unary.rb:
	# * abs
	# * magnitude

	def arg
		r_cos = real
		r_sin = imag.norm
		Math.atan2(r_sin, r_cos)
	end
	alias angle arg
	alias phase arg

	def axis
		v = imag
		norm = v.norm
		if norm.zero?
			# imag[0] == +0.0 -> q = r exp(+I PI)
			# imag[0] ==  0/1 -> q = r exp(+I PI)
			# imag[0] == -0.0 -> q = r exp(-I PI)
			sign = (1.0 / imag[0] >= 0) ? 1 : -1
			Vector[sign, 0, 0]
		else
			v / norm
		end
	end

	def polar
		[abs, arg, axis]
	end
end

#
# Generic constructor
#
# This accepts various arguments:
# * (Numeric)          -> real quaternion
# * (Numeric, Numeric) -> a+bj
# * (Numeric, Vector)  -> scalar and 3-D vector
# * (Numeric, Numeric, Numeric[, Numeric]) -> w+xi+yj+zk
# and String instead of Numeric.
#
module Kernel
	module_function

	def Quaternion(*args)
		argc = args.size

		unless (1..4).cover?(argc)
			raise ArgumentError,
			      "wrong number of arguments (given #{argc}, expected 1..4)"
		end

		if args.any?(&:nil?)
			raise TypeError, "can't convert nil into Quaternion"
		end

		# convert String into Numeric (strictly)
		args.collect! do |arg|
			case arg
			when String
				Quaternion.send(:parse, arg, true)
			else
				arg
			end
		end

		case argc
		when 1
			arg = args[0]
			if arg.kind_of?(Numeric)
				# a quaternion (or an octonion, etc.)
				return arg.complex? ? arg.to_q : arg
			else
				raise TypeError,
				      "can't convert #{arg.class} into Quaternion"
			end
		when 2
			if args[1].kind_of?(Enumerable)
				# scalar and 3-D vector -> expand
				if args[1].size != 3
					raise TypeError, "not a 3-D vector"
				end
				args.flatten!(1)
			elsif args.all? { |x| x.kind_of?(Numeric) && x.complex? }
				# a pair of complex numbers
				return Quaternion.send(:new, *args)
			else
				return args[0] + args[1] * Quaternion::J
			end
		end

		w, x, y, z = args
		z ||= 0
		if args.all? { |x| x.kind_of?(Numeric) && x.real? }
			# 3 or 4 real numbers
			a = Complex.rect(w, x)
			b = Complex.rect(y, z)
			Quaternion.send(:new, a, b)
		else
			a = Complex(w, x)
			b = Complex(y, z)
			if [a, b].all? { |x| x.kind_of?(Numeric) && x.complex? }
				Quaternion.send(:new, a, b)
			else
				a + b * Quaternion::J
			end
		end
	end
end
