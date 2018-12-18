require_relative 'base'
require_relative 'unary'

class Quaternion
	##
	# to_xxx
	#

	# defined by Numeric:
	# * to_int #=> to_i

	##
	# Returns self.
	#
	# @return [self]
	#
	def to_q
		self
	end

	##
	# Returns the value as a complex if possible (the discarded part should be exactly zero).
	#
	# @return [Complex]
	# @raise [RangeError] if its yj+zk part is not exactly zero.
	#
	def to_c
		unless __exact_zero__(@b)
			raise RangeError, "can't convert #{self} into Complex"
		end
		@a
	end

	##
	# @!method to_f
	#
	# Returns the value as a float if possible (the imaginary part should be exactly zero).
	#
	# @return [Float]
	# @raise [RangeError] if its imaginary part is not exactly zero.
	#

	##
	# @!method to_r
	#
	# Returns the value as a rational if possible (the imaginary part should be exactly zero).
	#
	# @return [Rational]
	# @raise [RangeError] if its imaginary part is not exactly zero.
	#

	##
	# @!method to_i
	#
	# Returns the value as an integer if possible (the imaginary part should be exactly zero).
	#
	# @return [Integer]
	# @raise [RangeError] if its imaginary part is not exactly zero.
	#

	##
	# @!method rationalize(eps = 0)
	#
	# Returns the value as a rational if possible (the imaginary part should be exactly zero).
	#
	# @param eps [Real]
	# @return [Rational]
	# @raise [RangeError] if its imaginary part is not exactly zero.
	#

	[:to_f, :to_r, :to_i, :rationalize].each do |sym|
		define_method(sym) { |*args| to_c.send(sym, *args) }
	end

	##
	# Returns the value as a string.
	#
	# @return [String]
	#
	# @example
	#   str = '1-2i-3/4j+0.56k'
	#   q = str.to_q #=> (1-2i-(3/4)*j+0.56k)
	#   q.to_s       #=> "1-2i-3/4j+0.56k"
	#
	def to_s
		__format__(:to_s)
	end

	##
	# Returns the value as a string for inspection.
	#
	# @return [String]
	#
	# @example
	#   str = '1-2i-3/4j+0.56k'
	#   q = str.to_q #=>  (1-2i-(3/4)*j+0.56k)
	#   q.inspect    #=> "(1-2i-(3/4)*j+0.56k)"
	#
	def inspect
		"(#{__format__(:inspect)})"
	end

	private

	def __format__(sym)
		w, *xyz = [@a, @b].flat_map(&:rect)
		sw = w.send(sym)
		sx, sy, sz = xyz.zip(%w[i j k]).collect do |num,base|
			if num.kind_of?(Float)
				str = num.send(sym)
				str[0,0] = '+' if str[0] != '-'
			elsif num < 0
				str = '-' + (-num).send(sym)
			else
				str = '+' + num.send(sym)
			end
			str << '*' if str[-1] !~ /\d/
			str << base
		end
		[sw, sx, sy, sz].join
	end

	class << self
		private

		def parse(str, strict = false)
			regexp = %r{
				\A
				\s*+
				(?:(?'real'   [+-]?+           \g'rational'  ) (?![ijk]))?+
				(?:(?'imag_i' \g'head_or_sign' \g'rational'?+) i        )?+
				(?:(?'imag_j' \g'head_or_sign' \g'rational'?+) j        )?+
				(?:(?'imag_k' \g'head_or_sign' \g'rational'?+) k        )?+
				\s*+
				|\z
				(?'head_or_sign' (?<=^|\s) [+-]?+ | [+-])
				(?'digits'       \d++ (?:#{strict ? "_" : "_++"} \d++)*+)
				(?'int_or_float' (?:\g'digits')?+ (?:\. \g'digits')?+
				                 (?<=\d) (?:e [+-]?+ \g'digits')?+)
				(?'rational'     \g'int_or_float' (?:/ \g'digits')?+)
			}xi

			# regexp.match(str) always succeeds (even if str is empty)
			components = regexp.match(str).captures[0,4]
			components = components.reverse.drop_while(&:nil?).reverse
			if strict && (!$'.empty? || components.empty?)
				raise ArgumentError,
				      "invalid value for convert(): #{str.inspect}"
			end

			components.collect! do |s|
				case s
				when %r{/}     then s.to_r
				when %r{[.eE]} then s.to_f
				when '+', ''   then 1
				when '-'       then -1
				else                s.to_i # Integer or nil
				end
			end

			# returns the parsed number as a preferred type
			case components.size
			when 0
				0
			when 1
				components[0]
			when 2
				Complex.rect(*components)
			else # 3 or 4
				w, x, y, z = components
				new(Complex.rect(w, x), Complex.rect(y, z || 0))
			end
		end
	end
end

class Numeric
	##
	# Returns the value as a quaternion.
	#
	# @return [Quaternion]
	#
	def to_q
		Quaternion.send(:new, self, 0)
	end
end

class String
	##
	# Returns a quaternion which denotes the string form.
	# The parser ignores leading whitespaces and trailing garbage.
	# Any digit sequences can be separated by an underscore.
	# Returns zero for null or garbage string.
	#
	# @return [Quaternion]
	#
	# @example
	#   "1-2i-3/4j+0.56k".to_q #=> (1-2i-(3/4)*j+0.56k)
	#   "foobarbaz".to_q       #=> (0+0i+0j+0k)
	#
	def to_q
		Quaternion.send(:parse, self, false).to_q
	end
end

class NilClass
	##
	# Returns zero as a quaternion.
	#
	# @return [Quaternion]
	#
	def to_q
		Quaternion.send(:new, 0, 0)
	end
end
