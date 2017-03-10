require_relative 'base'
require_relative 'unary'

#
# to_xxx
#

class Quaternion
	# defined by Numeric:
	# * to_int #=> to_i

	def to_q
		self
	end

	def to_c
		unless __exact_zero__(@b)
			raise RangeError, "can't convert #{self} into Complex"
		end
		@a
	end

	[:to_f, :to_r, :to_i, :rationalize].each do |sym|
		define_method(sym) { |*args| to_c.send(sym, *args) }
	end

	def to_s
		__format__(:to_s)
	end

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
				(?'int_or_float' (?:\g'digits')?+ (?:\. \g'digits')?+ (?<=\d) (?:e [+-]?+ \g'digits')?+)
				(?'rational'     \g'int_or_float' (?:/ \g'digits')?+)
			}xi

			match_data = regexp.match(str)
			if strict && (!$'.empty? || match_data.captures[0,4].all?(&:nil?))
				raise ArgumentError, "invalid value for convert(): #{str.inspect}"
			end

			w, x, y, z = match_data.captures[0,4].collect do |s|
				case s
				when %r{/}     then s.to_r
				when %r{[.eE]} then s.to_f
				when '+', ''   then 1
				when '-'       then -1
				else                s.to_i # Integer or nil
				end
			end

			new(Complex.rect(w, x), Complex.rect(y, z))
		end
	end
end

class Numeric
	def to_q
		Quaternion.send(:new, self, 0)
	end
end

class String
	def to_q
		Quaternion.send(:parse, self, false)
	end
end

class NilClass
	def to_q
		Quaternion.send(:new, 0, 0)
	end
end