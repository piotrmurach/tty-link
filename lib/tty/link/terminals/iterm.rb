# frozen_string_literal: true

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the iTerm terminal
      #
      # @api private
      class Iterm
        # The iTerm terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        ITERM = /iTerm(\s*\d+){0,1}.app/x.freeze
        private_constant :ITERM

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

        # Create an {TTY::Link::Terminals::Iterm} instance
        #
        # @example
        #   iterm = TTY::Link::Terminals::Iterm.new(SemanticVersion, ENV)
        #
        # @param [TTY::Link::SemanticVersion] semantic_version
        #   the semantic version creator
        # @param [ENV, Hash{String => String}] env
        #   the environment variables
        #
        # @api public
        def initialize(semantic_version, env)
          @semantic_version = semantic_version
          @env = env
        end

        # Detect iTerm hyperlink support
        #
        # @example
        #   iterm.link?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api public
        def link?
          name? && version?
        end

        private

        # Detect iTerm terminal
        #
        # @example
        #   iterm.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ ITERM).nil?
        end

        # Detect whether the iTerm version supports terminal hyperlinks
        #
        # @example
        #   iterm.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(3, 1, 0)
        end

        # Create a {TTY::Link::SemanticVersion} instance from a version value
        #
        # @example
        #   iterm.semantic_version(1, 2, 3)
        #
        # @example
        #   iterm.semantic_version("1.2.3")
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
        #   iterm.term_program
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
        #   iterm.term_program_version
        #   # => "1.2.3"
        #
        # @return [String, nil]
        #
        # @api private
        def term_program_version
          @env[TERM_PROGRAM_VERSION]
        end
      end # Iterm
    end # Terminals
  end # Link
end # TTY
