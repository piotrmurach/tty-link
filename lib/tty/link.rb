# frozen_string_literal: true

require_relative "link/version"

module TTY
  module Link
    class Error < StandardError; end

    ESC = "\u001B["
    OSC = "\u001B]"
    BEL = "\u0007"
    SEP = ";"

    ITERM = /iTerm(\s*\d+){0,1}.app/x

    # Parse version number
    #
    # @param [String] version
    #
    # @api private
    def parse_version(version)
      if matches = version.match(/^(\d{1,2})(\d{2})$/)
        major, minor, patch = 0, matches[1].to_i, matches[2].to_i
      else
        major, minor, patch = version.split(".").map(&:to_i)
      end
      {major: major, minor: minor, patch: patch}
    end
    module_function :parse_version

    # Check if link is supported
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

      # uses VTE terminal
      if ENV["VTE_VERSION"]
        version = parse_version(ENV["VTE_VERSION"])

        return version[:major] > 0 || version[:minor] > 50 ||
          version[:minor] == 50 && version[:patch] > 0
      end

      return false
    end
    module_function :support_link?

    # Render terminal link
    #
    # @param [String] name
    # @param [String] url
    #
    # @return [String]
    #
    # @api public
    def link_to(name, url)
      if support_link?
        [ OSC, "8", SEP, SEP, url, BEL, name, OSC, "8", SEP, SEP, BEL ].join("")
      else
        "#{name} -> #{url}"
      end
    end
    module_function :link_to
  end # Link
end # TTY
