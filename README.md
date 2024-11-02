<div align="center">
  <a href="https://ttytoolkit.org"><img width="130" src="https://github.com/piotrmurach/tty/raw/master/images/tty.png" alt="TTY Toolkit logo" /></a>
</div>

# TTY::Link

[![Gem Version](https://badge.fury.io/rb/tty-link.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/tty-link/actions/workflows/ci.yml/badge.svg)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/4vb3w6wmr9w9vfp7?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/3f8c368617c464238bf9/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-link/badge.svg)][coverage]

[gem]: https://badge.fury.io/rb/tty-link
[gh_actions_ci]: https://github.com/piotrmurach/tty-link/actions/workflows/ci.yml
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-link
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty-link/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-link

> Terminal hyperlinks support detection and generation.

**TTY::Link** detects whether the terminal supports hyperlinks and creates them
ready for display in the console. It is a component of the
[TTY toolkit](https://github.com/piotrmurach/tty).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tty-link"
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install tty-link
```

## Contents

* [1. Usage](#1-usage)
* [2. API](#2-api)
  * [2.1 new](#21-new)
    * [2.1.1 :env](#211-env)
    * [2.1.2 :output](#212-output)
    * [2.1.3 :hyperlink](#213-hyperlink)
    * [2.1.4 :plain](#214-plain)
  * [2.2 link?](#22-link)
  * [2.3 link_to](#23-link_to)
    * [2.3.1 :attrs](#231-attrs)
* [3. Supported Terminals](#3-supported-terminals)

## 1. Usage

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

## 2. API

### 2.1 new

#### 2.1.1 :env

The `new` method accepts the `:env` keyword to define environment variables.
The keyword defaults to the `ENV` object that holds the current environment
variables.

For example, to define only an environment variable `TTY_LINK_HYPERLINK` with
`always` value:

```ruby
link = TTY::Link.new(env: {"TTY_LINK_HYPERLINK" => "always"})
```

#### 2.1.2 :output

The `new` method accepts the `:output` keyword to define the output stream. The
keyword defaults to the standard output.

For example, to use the standard error stream:

```ruby
link = TTY::Link.new(output: $stderr)
```

#### 2.1.3 :hyperlink

The `new` method accepts the `:hyperlink` keyword to control terminal hyperlink
support detection. The available values are `:always`, `:auto` and `:never`. The
keyword defaults to the `:auto` value to allow the [link?](#22-link) method
to check whether the given terminal supports hyperlinks.

For example, use the `:always` value to force the [link_to](#23-link_to) method
to create hyperlinks without checking terminal support:

```ruby
link = TTY::Link.new(hyperlink: :always)
```

Or, use the `:never` value to force the [link_to](#23-link_to) to create
text-only links:

```ruby
link = TTY::Link.new(hyperlink: :never)
```

Alternatively, set the `TTY_LINK_HYPERLINK` environment variable to configure
the `:hyperlink` value:

```shell
TTY_LINK_HYPERLINK=always
```

#### 2.1.4 :plain

The `new` method accepts the `:plain` keyword to define a text-only hyperlink
replacement template. The [link_to](#23-link_to) method uses the template to
create a plain URL alternative on terminals without hyperlink support.

The template can contain two tokens, the `:name` and the `:url`. The tokens
are optional. The `:name -> :url` is the default template. The
[link_to](#23-link_to) method replaces the present token with the given
argument.

For example, given a link to `https://ttytoolkit.org` named `TTY Toolkit`:

```ruby
link.link_to("TTY Toolkit", "https://ttytoolkit.org")
```

This will create the following string from the default template:

```ruby
"TTY toolkit -> https://ttytoolkit.org"
```

To change the default template and display links, for example, with the name
and the URL surrounded by brackets:

```ruby
link = TTY::Link.new(plain: ":name (:url)")
```

Then passing the same arguments to the [link_to](#23-link_to) method:

```ruby
link.link_to("TTY Toolkit", "https://ttytoolkit.org")
```

This will create the following string from the custom template:

```ruby
"TTY toolkit (https://ttytoolkit.org)"
```

### 2.2 link?

The `link?` method detects whether the terminal supports hyperlinks against
[supported terminals](#3-supported-terminals). The [link_to](#23-link_to)
method uses this detection to decide whether to create a hyperlink or plain
text alternative.

For example, to check the current terminal hyperlink support:

```ruby
link.link?
```

### 2.3 link_to

The `link_to` method accepts two arguments, the name and the URL. The second
URL argument is optional.

For example, to create a hyperlink to `https://ttytoolkit.org`
named `TTY Toolkit`:

```ruby
link.link_to("TTY Toolkit", "https://ttytoolkit.org")
```

To create a hyperlink where the name is the same as the URL:

```ruby
link.link_to("https://ttytoolkit.org")
```

#### 2.3.1 :attrs

The `link_to` method accepts the `:attrs` keyword to define attributes for a
hyperlink. Note that currently, hyperlink-capable terminals support only the
`id` attribute. However, there is no limitation on the attribute names to
allow future support.

For example, to define the `id` attribute:

```ruby
link.link_to("TTY Toolkit", "https://ttytoolkit.org", attrs: {id: "tty-toolkit"})
```

To define many attributes such as `id`, `lang` and `title`:

```ruby
link.link_to("TTY Toolkit", "https://ttytoolkit.org", attrs: {
  id: "tty-toolkit", lang: "en", title: "Terminal Apps The Easy Way"
})
```

## 3. Supported Terminals

The **TTY::Link** supports hyperlink generation in the following terminals:

* `Alacritty`
* `Contour`
* `DomTerm`
* `foot`
* `Hyper`
* `iTerm2`
* `JediTerm`
* `kitty`
* `Konsole`
* `mintty`
* `Rio`
* `Tabby`
* `Terminology`
* `VSCode`
* `VTE (GNOME, Xfce, ROXTerm, Guake, sakura, Terminator)`
* `WezTerm`
* `Windows Terminal`

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console`
for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/piotrmurach/tty-link.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[code of conduct](https://github.com/piotrmurach/tty-link/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TTY::Link project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/piotrmurach/tty-link/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 Piotr Murach. See
[LICENSE.txt](https://github.com/piotrmurach/tty-link/blob/master/LICENSE.txt)
for further details.
