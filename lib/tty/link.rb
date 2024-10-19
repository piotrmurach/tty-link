# frozen_string_literal: true

require_relative "link/ansi_link"
require_relative "link/errors"
require_relative "link/hyperlink_parameter"
require_relative "link/plain_link"
require_relative "link/semantic_version"
require_relative "link/terminals"
require_relative "link/version"

module TTY
  # Responsible for detecting and generating terminal hyperlinks
  #
  # @api public
  class Link
    # The default plain URL template
    #
    # @return [String]
    #
    # @api private
    DEFAULT_TEMPLATE = ":name -> :url"
    private_constant :DEFAULT_TEMPLATE

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
    #                     hyperlink: :always)
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
    # @param [String, Symbol] hyperlink
    #   the hyperlink detection out of always, auto or never
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
    def self.link_to(name, url = nil, attrs: {}, env: ENV, hyperlink: :auto,
                     output: $stdout, plain: DEFAULT_TEMPLATE)
      new(env: env, hyperlink: hyperlink, output: output, plain: plain)
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
    #   link = TTY::Link.new(hyperlink: :always)
    #
    # @example
    #   link = TTY::Link.new(output: $stderr)
    #
    # @example
    #   link = TTY::Link.new(plain: ":name (:url)")
    #
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [String, Symbol] hyperlink
    #   the hyperlink detection out of always, auto or never
    # @param [IO] output
    #   the output stream, defaults to $stdout
    # @param [String] plain
    #   the plain URL template
    #
    # @api public
    def initialize(env: ENV, hyperlink: :auto, output: $stdout,
                   plain: DEFAULT_TEMPLATE)
      @env = env
      @hyperlink_parameter = hyperlink_parameter(hyperlink)
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

      if ansi_link?
        ansi_link(name, url, attrs).to_s
      else
        plain_link(name, url).to_s
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

    # Whether to create an {TTY::Link::ANSILink} or a {TTY::Link::PlainLink}
    #
    # @example
    #   link.ansi_link?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api private
    def ansi_link?
      @hyperlink_parameter.always? || (@hyperlink_parameter.auto? && link?)
    end

    # Create an {TTY::Link::ANSILink} instance
    #
    # @example
    #   ansi_link("TTY Toolkit", "https://ttytoolkit.org", {id: "tty-tookit"})
    #
    # @param [String] name
    #   the URL name
    # @param [String] url
    #   the URL target
    # @param [Hash{Symbol => String}] attrs
    #   the URL attributes
    #
    # @return [TTY::Link::ANSILink]
    #
    # @see ANSILink#new
    #
    # @api private
    def ansi_link(name, url, attrs)
      ANSILink.new(name, url, attrs)
    end

    # Create a {TTY::Link::HyperlinkParameter} instance
    #
    # @example
    #   link.hyperlink_parameter(:always)
    #
    # @param [String, Symbol] hyperlink
    #   the hyperlink detection out of always, auto or never
    #
    # @return [TTY::Link::HyperlinkParameter]
    #
    # @raise [TTY::Link::ValueError]
    #   the value isn't always, auto or never
    #
    # @api private
    def hyperlink_parameter(hyperlink)
      HyperlinkParameter.new(hyperlink)
    end

    # Create a {TTY::Link::PlainLink} instance
    #
    # @example
    #   plain_link("TTY Toolkit", "https://ttytoolkit.org")
    #
    # @param [String] name
    #   the URL name
    # @param [String] url
    #   the URL target
    #
    # @return [TTY::Link::PlainLink]
    #
    # @see PlainLink#new
    #
    # @api private
    def plain_link(name, url)
      PlainLink.new(name, url, @plain)
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
