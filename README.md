<div align="center">
  <a href="https://ttytoolkit.org"><img width="130" src="https://github.com/piotrmurach/tty/raw/master/images/tty.png" alt="tty logo" /></a>
</div>

# TTY::Link

[![Gem Version](https://badge.fury.io/rb/tty-link.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/tty-link/workflows/CI/badge.svg?branch=master)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/4vb3w6wmr9w9vfp7?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/3f8c368617c464238bf9/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-link/badge.svg)][coverage]

[gem]: https://badge.fury.io/rb/tty-link
[gh_actions_ci]: https://github.com/piotrmurach/tty-link/actions?query=workflow%3ACI
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-link
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty-link/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-link

> Hyperlinks in your terminal

**TTY::Link** allows you to test whether a terminal supports hyperlinks and print them to the console. It is a component in [TTY toolkit](https://github.com/piotrmurach/tty)

Terminal emulators such as `iTerm2` or `GNOME`, `XFCE` that use `VTE` widget support web style hyperlinks via `Ctrl+click` or `Cmd+click`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tty-link'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty-link

## Usage

To print hyperlink in your terminal do:

```ruby
puts TTY::Link.link_to("TTY toolkit", "https://ttytoolkit.org")
# =>
# TTY toolkit
```

In cases when the terminal cannot support hyperlinks, an alternative is printed:

```ruby
# TTY toolkit -> https://ttytoolkit.org
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotrmurach/tty-link. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/piotrmurach/tty-link/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TTY::Link project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotrmurach/tty-link/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 Piotr Murach. See LICENSE for further details.
