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
    # @param [ENV, Hash{String => String}] env
    #   the environment variables
    # @param [IO] output
    #   the output stream, defaults to $stdout
    #
    # @api public
    def initialize(env: ENV, output: $stdout)
      @env = env
      @output = output
      @semantic_version = SemanticVersion
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
      return false unless tty?

      return iterm_version? if iterm? && term_program_version

      return vte_version? if vte?

      false
    end

    private

    # Detect iTerm terminal
    #
    # @example
    #   link.iterm?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api private
    def iterm?
      !(term_program =~ ITERM).nil?
    end

    # Detect whether the iTerm version supports terminal hyperlinks
    #
    # @example
    #   link.iterm_version?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api private
    def iterm_version?
      current_semantic_version = semantic_version(term_program_version)

      current_semantic_version >= semantic_version(3, 1, 0)
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

    # Detect VTE terminal
    #
    # @example
    #   link.vte?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api private
    def vte?
      !vte_version.nil?
    end

    # Detect whether the VTE version supports terminal hyperlinks
    #
    # @example
    #   link.vte_version?
    #   # => true
    #
    # @return [Boolean]
    #
    # @api private
    def vte_version?
      current_semantic_version = semantic_version(vte_version)

      current_semantic_version >= semantic_version(0, 50, 1)
    end

    # Create a {TTY::Link::SemanticVersion} instance from a version value
    #
    # @example
    #   link.semantic_version(1, 2, 3)
    #
    # @example
    #   link.semantic_version("1.2.3")
    #
    # @param [Array<Integer, String>] version
    #   the version to convert to a semantic version
    # @param [Hash{Symbol => String}] options
    #   the options to convert to a semantic version
    # @option options [String] :separator
    #   the version separator
    #
    # @return [TTY::Link::SemanticVersion]
    #
    # @see SemanticVersion#from
    #
    # @api private
    def semantic_version(*version, **options)
      @semantic_version.from(*version, **options)
    end

    # Read the term program environment variable
    #
    # @example
    #   link.term_program
    #   # => "iTerm.app"
    #
    # @return [String, nil]
    #
    # @api private
    def term_program
      @env[TERM_PROGRAM]
    end

    # Read the term program version environment variable
    #
    # @example
    #   link.term_program_version
    #   # => "1.2.3"
    #
    # @return [String, nil]
    #
    # @api private
    def term_program_version
      @env[TERM_PROGRAM_VERSION]
    end

    # Read the VTE version environment variable
    #
    # @example
    #   link.vte_version
    #   # => "5100"
    #
    # @return [String, nil]
    #
    # @api private
    def vte_version
      @env[VTE_VERSION]
    end
  end # Link
end # TTY
