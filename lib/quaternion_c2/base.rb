##
# This class +Quaternion+ is an analogue of +Complex+.
# * A subclass of +Numeric+
# * Immutable instances
# * Common / extended methods
# Please +require 'quaternion_c2'+ to load all functions.
#
# +Quaternion+ has many constructors to accept
# the various representations of a quaternion.
# It is recommended to use +Kernel.#Quaternion+ and +Quaternion.polar+.
#
# @see https://ruby-doc.org/core/Complex.html
#
class Quaternion < Numeric
	attr_reader :a, :b
	protected   :a, :b

	##
	# @!visibility private
	#
	def initialize(a, b)
		@a = a.to_c
		@b = b.to_c
	end

	private_class_method :new


	private

	def __new__(a, b)
		Quaternion.send(:new, a, b)
	end
end
