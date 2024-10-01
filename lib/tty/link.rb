# frozen_string_literal: true

require_relative "link/ansi_link"
require_relative "link/errors"
require_relative "link/semantic_version"
require_relative "link/terminals"
require_relative "link/version"

module TTY
  # Responsible for detecting and generating terminal hyperlinks
  #
  # @api public
  class Link
    # The attribute separator
    #
    # @return [String]
    #
    # @api private
    ATTRIBUTE_SEPARATOR = "="
    private_constant :ATTRIBUTE_SEPARATOR

    # The attribute pair separator
    #
    # @return [String]
    #
    # @api private
    ATTRIBUTE_PAIR_SEPARATOR = ":"
    private_constant :ATTRIBUTE_PAIR_SEPARATOR

    # The bell control code
    #
    # @return [String]
    #
    # @api private
    BEL = "\a"
    private_constant :BEL

    # The default plain URL template
    #
    # @return [String]
    #
    # @api private
    DEFAULT_TEMPLATE = ":name -> :url"
    private_constant :DEFAULT_TEMPLATE

    # The hyperlink operating system command code
    #
    # @return [String]
    #
    # @api private
    OSC8 = "\e]8"
    private_constant :OSC8

    # The replacement tokens pattern
    #
    # @return [Regexp]
    #
    # @api private
    REPLACEMENT_TOKENS_PATTERN = /:(name|url)/i.freeze
    private_constant :REPLACEMENT_TOKENS_PATTERN

    # The parameters separator
    #
    # @return [String]
    #
    # @api private
    SEP = ";"
    private_constant :SEP

    # Generate terminal hyperlink
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org")
    #
    # @example
    #   TTY::Link.link_to("https://ttytoolkit.org")
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                     attrs: {id: "tty-toolkit"})
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                     env: {"VTE_VERSION" => "7603"})
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                     output: $stderr)
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                     plain: ":name (:url)")
    #
    # @param [String] name
    #   the name for the URL
    # @param [String, nil] url
    #   the URL target
    # @param [Hash{Symbol => String}] attrs
    #   the URL attributes
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [IO] output
    #   the output stream, defaults to $stdout
    # @param [String] plain
    #   the plain URL template
    #
    # @return [String]
    #
    # @see #link_to
    #
    # @api public
    def self.link_to(name, url = nil, attrs: {}, env: ENV, output: $stdout,
                     plain: DEFAULT_TEMPLATE)
      new(env: env, output: output, plain: plain)
        .link_to(name, url, attrs: attrs)
    end

    # Detect terminal hyperlink support
    #
    # @example
    #   TTY::Link.link?
    #   # => true
    #
    # @example
    #   TTY::Link.link?(env: {"VTE_VERSION" => "7603"})
    #   # => true
    #
    # @example
    #   TTY::Link.link?(output: $stderr)
    #   # => false
    #
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [IO] output
    #   the output stream, defaults to $stdout
    #
    # @return [Boolean]
    #
    # @see #link?
    #
    # @api public
    def self.link?(env: ENV, output: $stdout)
      new(env: env, output: output).link?
    end

    # Create a {TTY::Link} instance
    #
    # @example
    #   link = TTY::Link.new
    #
    # @example
    #   link = TTY::Link.new(env: {"VTE_VERSION" => "7603"})
    #
    # @example
    #   link = TTY::Link.new(output: $stderr)
    #
    # @example
    #   link = TTY::Link.new(plain: ":name (:url)")
    #
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [IO] output
    #   the output stream, defaults to $stdout
    # @param [String] plain
    #   the plain URL template
    #
    # @api public
    def initialize(env: ENV, output: $stdout, plain: DEFAULT_TEMPLATE)
      @env = env
      @output = output
      @plain = plain
    end

    # Generate terminal hyperlink
    #
    # @example
    #   link.link_to("TTY Toolkit", "https://ttytoolkit.org")
    #
    # @example
    #   link.link_to("https://ttytoolkit.org")
    #
    # @example
    #   link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                attrs: {id: "tty-toolkit"})
    #
    # @example
    #   link.link_to("https://ttytoolkit.org",
    #                attrs: {id: "tty-toolkit", title: "TTY Toolkit"})
    #
    # @param [String] name
    #   the name for the URL
    # @param [String, nil] url
    #   the URL target
    # @param [Hash{Symbol => String}] attrs
    #   the URL attributes
    #
    # @return [String]
    #
    # @api public
    def link_to(name, url = nil, attrs: {})
      url ||= name

      if link?
        attributes = convert_to_attributes(attrs)
        [OSC8, SEP, attributes, SEP, url, BEL, name, OSC8, SEP, SEP, BEL].join
      else
        replacements = {":name" => name, ":url" => url}
        @plain.gsub(REPLACEMENT_TOKENS_PATTERN, replacements)
      end
    end

    # Detect terminal hyperlink support
    #
    # @example
    #   link.link?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api public
    def link?
      return false unless tty?

      terminals.any?(&:link?)
    end

    private

    # Convert the attributes hash to a string list
    #
    # @example
    #   link.convert_to_attributes({id: "tty-toolkit", title: "TTY Toolkit"})
    #   # => "id=tty-toolkit:title=TTY Toolkit"
    #
    # @param [Hash{Symbol => String}] attrs
    #   the attributes to convert to a string list
    #
    # @return [String]
    #
    # @api private
    def convert_to_attributes(attrs)
      attrs.map do |attr_pair|
        attr_pair.join(ATTRIBUTE_SEPARATOR)
      end.join(ATTRIBUTE_PAIR_SEPARATOR)
    end

    # Terminals for detecting hyperlink support
    #
    # @example
    #   link.terminals
    #
    # @return [Array<TTY::Link::Terminals::Abstract>]
    #
    # @api private
    def terminals
      @terminals ||= Terminals.registered.map do |terminal_class|
        terminal_class.new(SemanticVersion, @env)
      end
    end

    # Detect the terminal device
    #
    # @example
    #   link.tty?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api private
    def tty?
      @output.tty?
    end
  end # Link
end # TTY
