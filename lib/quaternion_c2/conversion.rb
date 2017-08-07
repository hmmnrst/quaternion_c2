require_relative 'base'
require_relative 'classification'
require_relative 'unary'
require_relative 'units'
require_relative 'arithmetic'
require_relative 'to_type'

require 'matrix'

class Quaternion
	##
	# Constructors
	#

	class << self
		##
		# Returns a quaternion object a+bj, where both a and b are complex (or real).
		#
		# @param a [Complex]
		# @param b [Complex]
		# @return [Quaternion]
		# @raise [TypeError]
		#
		# @example
		#   Quaternion.rect(1, Complex::I) #=> (1+0i+0j+1k)
		#
		def rect(a, b = 0)
			unless [a, b].all? { |c| c.kind_of?(Numeric) && c.complex? }
				raise TypeError, 'not a complex'
			end
			new(a, b)
		end
		alias rectangular rect

		##
		# Returns a quaternion object w+xi+yj+zk, where all of w, x, y, and z are real.
		#
		# @param w [Real]
		# @param x [Real]
		# @param y [Real]
		# @param z [Real]
		# @return [Quaternion]
		# @raise [TypeError]
		#
		# @example
		#   Quaternion.hrect(1, 2, 3, 4) #=> (1+2i+3j+4k)
		#
		def hrect(w, x = 0, y = 0, z = 0)
			a = Complex.rect(w, x)
			b = Complex.rect(y, z)
			new(a, b)
		end
		alias hyperrectangular hrect

		##
		# Returns a quaternion object which denotes the given polar form.
		# The actual angle is recognized as +theta * vector.norm+.
		#
		# @param r      [Real]       absolute value
		# @param theta  [Real]       angle in radians
		# @param vector [Enumerable] 3-D vector
		# @return [Quaternion]
		# @raise [TypeError]
		#
		# @example
		#   Quaternion.polar(1, Math::PI/3, Vector[1,1,1].normalize)
		#   #=> (0.5000000000000001+0.5i+0.5j+0.5k)
		#   Quaternion.polar(1, 1, Math::PI/3 * Vector[1,1,1].normalize)
		#   #=> (0.4999999999999999+0.5i+0.5j+0.5k)
		#
		#   r, theta = -3, -1
		#   Quaternion.polar(r)        == r                       #=> true
		#   Quaternion.polar(r, theta) == Complex.polar(r, theta) #=> true
		#
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

	##
	# Accessors
	#

	##
	# Returns an array of two complex numbers.
	#
	# @return [[Complex, Complex]]
	#
	# @example
	#   Quaternion('1+2i+3j+4k').rect #=> [(1+2i), (3+4i)]
	#
	def rect
		[@a, @b]
	end
	alias rectangular rect

	##
	# Returns an array of four real numbers.
	#
	# @return [[Real, Real, Real, Real]]
	#
	# @example
	#   Quaternion('1+2i+3j+4k').hrect #=> [1, 2, 3, 4]
	#
	def hrect
		rect.flat_map(&:rect)
	end
	alias hyperrectangular hrect

	##
	# Returns the real part.
	#
	# @return [Real]
	#
	# @example
	#   Quaternion('1+2i+3j+4k').real #=> 1
	#
	def real
		@a.real
	end
	alias scalar real

	##
	# Returns the imaginary part as a 3-D vector.
	#
	# @return [Vector] 3-D vector
	#
	# @example
	#   Quaternion('1+2i+3j+4k').imag #=> Vector[2, 3, 4]
	#
	def imag
		Vector[*hrect.drop(1)]
	end
	alias imaginary imag
	alias vector imag

	# defined in unary.rb:
	# * abs
	# * magnitude

	##
	# Returns the angle part of its polar form.
	#
	# @return [Real]
	#
	# @example
	#   Quaternion('1+i+j+k').arg #=> Math::PI/3
	#
	def arg
		r_cos = real
		r_sin = imag.norm
		Math.atan2(r_sin, r_cos)
	end
	alias angle arg
	alias phase arg

	##
	# Returns the axis part of its polar form.
	#
	# @return [Vector] normalized 3-D vector
	#
	# @example
	#   Quaternion('1+i+j+k').axis #=> Vector[1,1,1].normalize
	#
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

	##
	# Returns an array; +[q.abs, q.arg, q.axis]+.
	#
	# @return [[Real, Real, Vector]]
	#
	# @example
	#   Quaternion('1+i+j+k').polar
	#   #=> [2.0, Math::PI/3, Vector[1,1,1].normalize]
	#
	def polar
		[abs, arg, axis]
	end
end

module Kernel
	module_function

	##
	# Returns a quaternion.
	#
	# This function accepts various arguments except polar form.
	# Strings are parsed to +Numeric+.
	#
	# @overload Quaternion(w, x, y, z)
	#   @param w [Numeric]
	#   @param x [Numeric]
	#   @param y [Numeric]
	#   @param z [Numeric]
	#   @return [Quaternion] w+xi+yj+zk
	# @overload Quaternion(a, b)
	#   @param a [Numeric]
	#   @param b [Numeric]
	#   @return [Quaternion] a+bj
	# @overload Quaternion(s, v)
	#   @param s [Numeric]    scalar part
	#   @param v [Enumerable] vector part
	#   @return [Quaternion] $s+\\vec!{v}$
	# @overload Quaternion(str)
	#   @param str [String]
	#   @return [Quaternion] +str.to_q+
	#   @raise [ArgumentError] if its format is inexact.
	#
	# @example
	#   Quaternion(1)            #=> (1+0i+0j+0k)
	#   Quaternion(1, 2)         #=> (1+0i+2j+0k) # not (1+2i+0j+0k)
	#   Quaternion(1, 2, 3, 4)   #=> (1+2i+3j+4k)
	#   Quaternion(1, [2, 3, 4]) #=> (1+2i+3j+4k)
	#   Quaternion('1+2i+3j+4k') #=> (1+2i+3j+4k)
	#
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
		when 2
			if args[1].kind_of?(Enumerable)
				# scalar and 3-D vector
				if args[1].size != 3
					raise TypeError, "not a 3-D vector"
				end
				args = [args[0], *args[1]]
			else
				# a pair of complex numbers
				return args[0] + args[1] * Quaternion::J
			end
		end

		# maximum four real numbers
		i = Quaternion::I
		j = Quaternion::J
		k = Quaternion::K
		zero = Quaternion.send(:new, 0, 0)
		args.zip([1, i, j, k]).inject(zero) do |sum,(num,base)|
			sum + num * base
		end
	end
end
