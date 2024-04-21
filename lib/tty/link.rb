# frozen_string_literal: true

require_relative "link/errors"
require_relative "link/version"

module TTY
  # Responsible for detecting and generating terminal hyperlinks
  #
  # @api public
  module Link
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

    # Generate terminal hyperlink
    #
    # @example
    #   TTY::Link.link_to("TTY Toolkit", "https://ttytoolkit.org")
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
      if support_link?
        [OSC8, SEP, SEP, url, BEL, name, OSC8, SEP, SEP, BEL].join
      else
        "#{name} -> #{url}"
      end
    end
    module_function :link_to

    # Detect terminal hyperlink support
    #
    # @example
    #   TTY::Link.support_link?
    #   # => true
    #
    # @example
    #   TTY::Link.support_link?(output: $stderr)
    #   # => false
    #
    # @param [IO] output
    #   the output stream, defaults to $stdout
    #
    # @return [Boolean]
    #
    # @api public
    def support_link?(output: $stdout)
      return false unless output.tty?

      if ENV[TERM_PROGRAM] =~ ITERM && ENV[TERM_PROGRAM_VERSION]
        version = parse_version(ENV[TERM_PROGRAM_VERSION])

        return version[:major] > 3 || version[:major] == 3 && version[:minor] > 0
      end

      if ENV["VTE_VERSION"]
        version = parse_version(ENV["VTE_VERSION"])

        return version[:major] > 0 || version[:minor] > 50 ||
               version[:minor] == 50 && version[:patch] > 0
      end

      false
    end
    module_function :support_link?

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
    # @param [String] version
    #   the version to parse
    #
    # @return [Hash{Symbol => Integer, nil}]
    #
    # @api private
    def parse_version(version)
      if (matches = version.match(/^(\d{1,2})(\d{2})$/))
        major, minor, patch = 0, matches[1].to_i, matches[2].to_i
      else
        major, minor, patch = version.split(".").map(&:to_i)
      end
      {major: major, minor: minor, patch: patch}
    end
    module_function :parse_version
  end # Link
end # TTY
