# frozen_string_literal: true

require_relative "link/errors"
require_relative "link/version"

module TTY
  # Responsible for detecting and generating terminal hyperlinks
  #
  # @api public
  module Link
    # The ANSI escape sequence code
    #
    # @return [String]
    #
    # @api private
    ESC = "\u001B["

    # The operating system command code
    #
    # @return [String]
    #
    # @api private
    OSC = "\u001B]"

    # The bell control code
    #
    # @return [String]
    #
    # @api private
    BEL = "\u0007"

    # The parameters separator
    #
    # @return [String]
    #
    # @api private
    SEP = ";"

    # The iTerm terminal name pattern
    #
    # @return [Regexp]
    #
    # @api private
    ITERM = /iTerm(\s*\d+){0,1}.app/x.freeze

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

      if ENV["TERM_PROGRAM"] =~ ITERM
        version = parse_version(ENV["TERM_PROGRAM_VERSION"])

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
        [OSC, "8", SEP, SEP, url, BEL, name, OSC, "8", SEP, SEP, BEL].join
      else
        "#{name} -> #{url}"
      end
    end
    module_function :link_to
  end # Link
end # TTY
