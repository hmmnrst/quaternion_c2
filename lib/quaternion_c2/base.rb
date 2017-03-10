class Quaternion < Numeric
	attr_reader :a, :b
	protected   :a, :b

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
