# Quaternion

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quaternion_c2', :git => 'git://github.com/hmmnrst/quaternion_c2.git'
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hmmnrst/quaternion_c2.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

