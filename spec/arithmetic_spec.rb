require "spec_helper"
require "quaternion_c2/arithmetic"
require "quaternion_c2/equality" # define Quaternion#eql?

RSpec.describe Quaternion do
	shared_examples_for "correct answer" do
		it "should eql to the correct answer" do
			is_expected.to eql result
		end
	end

	describe "#+" do
		subject { num1 + num2 }

		context "Quaternion + Quaternion" do
			let(:num1) { Quaternion.send(:new, Complex(1, 2), Complex(3.0, 4.0)) }
			let(:num2) { Quaternion.send(:new, Complex(1, 2.0), Complex(3, 4.0)) }
			let(:result) { Quaternion.send(:new, Complex(2, 4.0), Complex(6.0, 8.0)) }
			include_examples "correct answer"
		end

		context "Quaternion + Complex" do
			let(:num1) { Quaternion.send(:new, Complex(1, 2), Complex(3.0, 4.0)) }
			let(:num2) { Complex(1, 2.0) }
			let(:result) { Quaternion.send(:new, Complex(2, 4.0), Complex(3.0, 4.0)) }
			include_examples "correct answer"
		end

		context "Complex + Quaternion" do
			let(:num1) { Complex(1, 2.0) }
			let(:num2) { Quaternion.send(:new, Complex(1, 2), Complex(3.0, 4.0)) }
			let(:result) { Quaternion.send(:new, Complex(2, 4.0), Complex(3.0, 4.0)) }
			include_examples "correct answer"
		end
	end

	describe "#-" do
		subject { num1 - num2 }

		context "Quaternion - Quaternion" do
			let(:num1) { Quaternion.send(:new, Complex(1, 2), Complex(3.0, 4.0)) }
			let(:num2) { Quaternion.send(:new, Complex(1, 2.0), Complex(3, 4.0)) }
			let(:result) { Quaternion.send(:new, Complex(0, 0.0), Complex(0.0, 0.0)) }
			include_examples "correct answer"
		end

		context "Quaternion - Complex" do
			let(:num1) { Quaternion.send(:new, Complex(1, 2), Complex(3, 4.0)) }
			let(:num2) { Complex(1, 2.0) }
			let(:result) { Quaternion.send(:new, Complex(0, 0.0), Complex(3, 4.0)) }
			include_examples "correct answer"
		end

		context "Complex - Quaternion" do
			let(:num1) { Complex(1, 2.0) }
			let(:num2) { Quaternion.send(:new, Complex(1, 2), Complex(3, 4.0)) }
			let(:result) { Quaternion.send(:new, Complex(0, 0.0), Complex(-3, -4.0)) }
			include_examples "correct answer"
		end
	end

	describe "#*" do
		subject { num1 * num2 }

		context "Quaternion * Quaternion" do
			let(:num1) { Quaternion.send(:new, Complex(1, 1), Complex(1, -1)) }
			let(:num2) { Quaternion.send(:new, Complex(1, -1), Complex(1, 1)) }
			let(:result) { Quaternion.send(:new, Complex(2, 2), Complex(2, 2)) }
			include_examples "correct answer"
		end

		context "Quaternion * Complex" do
			let(:num1) { Quaternion.send(:new, Complex(1, Rational(2, 1)), Complex(3, 4.0)) }
			let(:num2) { Complex::I }
			let(:result) { Quaternion.send(:new, Complex(-2, 1) / 1, Complex(4.0, -3.0)) }
			include_examples "correct answer"
		end

		context "Complex * Quaternion" do
			let(:num1) { Complex::I }
			let(:num2) { Quaternion.send(:new, Complex(1, Rational(2, 1)), Complex(3, 4.0)) }
			let(:result) { Quaternion.send(:new, Complex(-2.0, 1.0), Complex(-4.0, 3.0)) }
			include_examples "correct answer"
		end
	end

	describe "#/" do
		subject { num1 / num2 }

		context "Quaternion / Quaternion" do
			let(:num1) { Quaternion.send(:new, Complex(2, 2), Complex(2, 2)) }
			let(:num2) { Quaternion.send(:new, Complex(1, -1), Complex(1, 1)) }
			let(:result) { Quaternion.send(:new, Complex(1, 1) / 1, Complex(1, -1) / 1) }
			include_examples "correct answer"
		end

		context "Quaternion / Complex" do
			let(:num1) { Quaternion.send(:new, Complex(1, Rational(2, 1)), Complex(3, 4.0)) }
			let(:num2) { Complex::I }
			let(:result) { Quaternion.send(:new, Complex(2, -1) / 1, Complex(-4.0, 3.0)) }
			include_examples "correct answer"
		end

		context "Complex / Quaternion" do
			let(:num1) { Complex::I * 25 }
			let(:num2) { Quaternion.send(:new, Complex(1, Rational(2, 1)), Complex(2, 4.0)) }
			let(:result) { Quaternion.send(:new, Complex(2.0, 1.0), Complex(4.0, -2.0)) }
			include_examples "correct answer"
		end

		shared_context "dividends" do
			let(:c00) { Complex.rect(1, 1) }
			let(:c01) { Complex.rect(1, 1.0) }
			let(:c10) { Complex.rect(1.0, 1) }
			let(:c11) { Complex.rect(1.0, 1.0) }
			let(:q0000) { Quaternion.send(:new, c00, c00) }
			let(:q0001) { Quaternion.send(:new, c00, c01) }
			let(:q0011) { Quaternion.send(:new, c00, c11) }
			let(:q0101) { Quaternion.send(:new, c01, c01) }
			let(:q0111) { Quaternion.send(:new, c01, c11) }
			let(:q1111) { Quaternion.send(:new, c11, c11) }
		end

		context "when divided by an exact zero Quaternion" do
			include_context "dividends"
			it "always raises error" do
				zero = Quaternion.send(:new, 0, 0)
				expect { q0000 / zero }.to raise_error ZeroDivisionError
				expect { q0001 / zero }.to raise_error ZeroDivisionError
				expect { q0011 / zero }.to raise_error ZeroDivisionError
				expect { q0101 / zero }.to raise_error ZeroDivisionError
				expect { q0111 / zero }.to raise_error ZeroDivisionError
				expect { q1111 / zero }.to raise_error ZeroDivisionError
			end
		end

		context "when divided by a float zero Quaternion" do
			include_context "dividends"
			it "never raises error" do
				zero = Quaternion.send(:new, 0, 0.0)
				expect { q0000 / zero }.not_to raise_error
				expect { q0001 / zero }.not_to raise_error
				expect { q0011 / zero }.not_to raise_error
				expect { q0101 / zero }.not_to raise_error
				expect { q0111 / zero }.not_to raise_error
				expect { q1111 / zero }.not_to raise_error
			end
		end

		context "when divided by an exact zero Real" do
			include_context "dividends"
			it "raises error when a dividend quaternion has non-float components" do
				zero = Rational(0, 1)
				expect { q0000 / zero }.to raise_error ZeroDivisionError
				expect { q0001 / zero }.to raise_error ZeroDivisionError
				expect { q0011 / zero }.to raise_error ZeroDivisionError
				expect { q0101 / zero }.to raise_error ZeroDivisionError
				expect { q0111 / zero }.to raise_error ZeroDivisionError
				expect { q1111 / zero }.not_to raise_error
			end
		end
	end
end
