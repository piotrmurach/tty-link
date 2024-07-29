# frozen_string_literal: true

require_relative "link/errors"
require_relative "link/semantic_version"
require_relative "link/version"

module TTY
  # Responsible for detecting and generating terminal hyperlinks
  #
  # @api public
  class Link
    # The bell control code
    #
    # @return [String]
    #
    # @api private
    BEL = "\a"
    private_constant :BEL

    # The iTerm terminal name pattern
    #
    # @return [Regexp]
    #
    # @api private
    ITERM = /iTerm(\s*\d+){0,1}.app/x.freeze
    private_constant :ITERM

    # The hyperlink operating system command code
    #
    # @return [String]
    #
    # @api private
    OSC8 = "\e]8"
    private_constant :OSC8

    # The parameters separator
    #
    # @return [String]
    #
    # @api private
    SEP = ";"
    private_constant :SEP

    # The term program environment variable name
    #
    # @return [String]
    #
    # @api private
    TERM_PROGRAM = "TERM_PROGRAM"
    private_constant :TERM_PROGRAM

    # The term program version environment variable name
    #
    # @return [String]
    #
    # @api private
    TERM_PROGRAM_VERSION = "TERM_PROGRAM_VERSION"
    private_constant :TERM_PROGRAM_VERSION

    # The unseparated version pattern
    #
    # @return [Regexp]
    #
    # @api private
    UNSEPARATED_VERSION_PATTERN = /^(\d{1,2})(\d{2})$/.freeze
    private_constant :UNSEPARATED_VERSION_PATTERN

    # The version separator
    #
    # @return [String]
    #
    # @api private
    VERSION_SEPARATOR = "."
    private_constant :VERSION_SEPARATOR

    # The VTE version environment variable name
    #
    # @return [String]
    #
    # @api private
    VTE_VERSION = "VTE_VERSION"
    private_constant :VTE_VERSION

    # Generate terminal hyperlink
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org")
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                     env: {"VTE_VERSION" => "7603"})
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org",
    #                     output: $stderr)
    #
    # @param [String] name
    #   the name for the URL
    # @param [String] url
    #   the URL target
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [IO] output
    #   the output stream, defaults to $stdout
    #
    # @return [String]
    #
    # @see #link_to
    #
    # @api public
    def self.link_to(name, url, env: ENV, output: $stdout)
      new(env: env, output: output).link_to(name, url)
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

    # Create a TTY::Link instance
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
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [IO] output
    #   the output stream, defaults to $stdout
    #
    # @api public
    def initialize(env: ENV, output: $stdout)
      @env = env
      @output = output
    end

    # Generate terminal hyperlink
    #
    # @example
    #   link.link_to("TTY Toolkit", "https://ttytoolkit.org")
    #
    # @param [String] name
    #   the name for the URL
    # @param [String] url
    #   the URL target
    #
    # @return [String]
    #
    # @api public
    def link_to(name, url)
      if link?
        [OSC8, SEP, SEP, url, BEL, name, OSC8, SEP, SEP, BEL].join
      else
        "#{name} -> #{url}"
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
      return false unless @output.tty?

      if @env[TERM_PROGRAM] =~ ITERM && @env[TERM_PROGRAM_VERSION]
        version = parse_version(@env[TERM_PROGRAM_VERSION])

        return version[:major] > 3 || version[:major] == 3 && version[:minor] > 0
      end

      if @env[VTE_VERSION]
        version = parse_version(@env[VTE_VERSION])

        return version[:major] > 0 || version[:minor] > 50 ||
               version[:minor] == 50 && version[:patch] > 0
      end

      false
    end

    # Parse version number
    #
    # @example
    #   TTY::Link.parse_version("1234")
    #   # => {major: 0, minor: 12, patch: 34}
    #
    # @example
    #   TTY::Link.parse_version("1.2.3")
    #   # => {major: 1, minor: 2, patch: 3}
    #
    # @example
    #   TTY::Link.parse_version("1-2-3", separator: "-")
    #   # => {major: 1, minor: 2, patch: 3}
    #
    # @param [String] version
    #   the version to parse
    # @param [String] separator
    #   the version separator
    #
    # @return [Hash{Symbol => Integer}]
    #
    # @api private
    def parse_version(version, separator: VERSION_SEPARATOR)
      if (matches = version.match(UNSEPARATED_VERSION_PATTERN))
        major, minor, patch = 0, matches[1], matches[2]
      else
        major, minor, patch = version.split(separator)
      end
      {major: major.to_i, minor: minor.to_i, patch: patch.to_i}
    end
  end # Link
end # TTY
