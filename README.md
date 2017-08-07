# Quaternion

This gem provides a `Quaternion` class highly compatible with other numeric classes.

The [quaternions](https://en.wikipedia.org/wiki/Quaternion) are an extension of complex numbers.
They have an important application to calculations of spatial rotations, such as in 3DCG.

A quaternion can be represented in several forms:

* Four real numbers: `$w + xi + yj + zk$`
* Two complex numbers: `$a + bj$`
* Scalar and 3-D vector: `$s + \vec{v}$`
* Polar form: `$r \exp{(\vec{n} \theta)}$`

where i, j, and k are imaginary units which satisfy $i^2 = j^2 = k^2 = ijk = -1$.
A scalar is a real quaternion and a vector is a pure imaginary quaternion.

The multiplication of quaternions is noncommutative unlike complex numbers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quaternion_c2'
```

And then execute:

    $ bundle

## Usage

`Quaternion` is similar to a built-in class `Complex`.

There are several methods to create a quaternion.  `Kernel.#Quaternion` accepts many patterns of arguments.

```ruby
require 'quaternion_c2'

q1 = Quaternion.rect(Complex(1, 2), Complex(3, 4))  #=> (1+2i+3j+4k)
q2 = Quaternion.hrect(1, -2, Rational(-3, 4), 0.56) #=> (1-2i-(3/4)*j+0.56k)
vector = Vector[1, 1, 1].normalize
q3 = Quaternion.polar(1, Math::PI / 3, vector)      #=> (0.5+0.5i+0.5j+0.5k)
q4 = Quaternion(1, [2, 3, 4])                       #=> (1+2i+3j+4k)

q1.rect  #=> [(1+2i), (3+4i)]
q2.hrect #=> [1, -2, (-3/4), 0.56]
q3.polar #=> [1.0, Math::PI / 3, vector]
q4.real  #=> 1
q4.imag  #=> Vector[2, 3, 4]

Complex::I.to_q     #=> (0+1i+0j+0k)
1 + 2.i + 3.j + 4.k #=> (1+2i+3j+4k)
```

`Quaternion` supports standard calculations between numeric instances.

```ruby
Complex::I * Quaternion::J  #=> (0+0i+0j+1k)
1 / Quaternion::I           #=> ((0/1)-(1/1)*i+(0/0)*j+(0/0)*k)
Quaternion(1, 1, 1, 1) ** 6 #=> (64+0i+0j+0k)
```

### Spatial rotations

Unit quaternions are often used to calculate 3-D rotations around arbitrary axes.
They have a compact form, avoid gimbal lock, and easily interpolate between themselves (see [Slerp](https://en.wikipedia.org/wiki/Slerp)).

```ruby
# theta = 120 * (Math::PI / 180)
# axis = Vector[1, 1, 1].normalize
# q = Quaternion.polar(1, theta / 2, axis)
q = Quaternion(0.5, 0.5, 0.5, 0.5)
r = Quaternion('2i+3j+4k')

r_new = q * r / q      #=> (0.0+4.0i+2.0j+3.0k)
r_new = q * r * q.conj #=> (0.0+4.0i+2.0j+3.0k) # q.abs must be 1
```

More generally, a pair of unit quaternions represents a [4-D rotation](https://en.wikipedia.org/wiki/Rotations_in_4-dimensional_Euclidean_space).

```ruby
ql = Quaternion(0.5,  0.5, -0.5, 0.5)
qr = Quaternion(0.5, -0.5,  0.5, 0.5)
r = Quaternion('1+2i+3j+4k')

r_new = ql * r * qr #=> (-4.0-3.0i-2.0j+1.0k)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hmmnrst/quaternion_c2.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

