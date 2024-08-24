# frozen_string_literal: true

require_relative "../errors"

module TTY
  class Link
    module Terminals
      # Responsible for providing common terminal detection
      #
      # @abstract Override {#name?} and {#version?} to implement
      #           terminal hyperlinks detection
      #
      # @api private
      class Abstract
        # The term environment variable name
        #
        # @return [String]
        #
        # @api private
        TERM = "TERM"
        private_constant :TERM

        # Register a terminal class with terminals
        #
        # @param [TTY::Link::Terminal::Abstract] terminal_class
        #   the terminal class to register
        #
        # @return [void]
        #
        # @api private
        def self.inherited(terminal_class)
          super
          Terminals.register(terminal_class)
        end
        private_class_method :inherited

        # Create an {TTY::Link::Terminals::Abstract} instance
        #
        # @example
        #   terminal = TTY::Link::Terminals::Abstract.new(SemanticVersion, ENV)
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

        # Detect a terminal hyperlink support
        #
        # @example
        #   terminal.link?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api public
        def link?
          name? && version?
        end

        protected

        # Detect a terminal name
        #
        # @example
        #   terminal.name?
        #
        # @raise [TTY::Link::AbstractMethodError]
        #   the class doesn't implement the name? method
        #
        # @abstract
        #
        # @api private
        def name?
          raise AbstractMethodError.new(self.class.name, __method__)
        end

        # Detect whether a terminal version supports terminal hyperlinks
        #
        # @example
        #   terminal.version?
        #
        # @raise [TTY::Link::AbstractMethodError]
        #   the class doesn't implement the version? method
        #
        # @abstract
        #
        # @api private
        def version?
          raise AbstractMethodError.new(self.class.name, __method__)
        end

        # The environment variables
        #
        # @example
        #   terminal.env
        #
        # @return [ENV, Hash{String => String}]
        #
        # @api private
        attr_reader :env

        # Create a {TTY::Link::SemanticVersion} instance from a version value
        #
        # @example
        #   terminal.semantic_version(1, 2, 3)
        #
        # @example
        #   terminal.semantic_version("1.2.3")
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

        # Read the term environment variable
        #
        # @example
        #   terminal.term
        #   # => "alacritty"
        #
        # @return [String, nil]
        #
        # @api private
        def term
          env[TERM]
        end
      end # Abstract
    end # Terminals
  end # Link
end # TTY
