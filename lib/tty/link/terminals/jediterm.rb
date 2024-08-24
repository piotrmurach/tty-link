# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the JediTerm terminal
      #
      # @api private
      class Jediterm < Abstract
        # The JediTerm terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        JEDITERM = /JediTerm/i.freeze
        private_constant :JEDITERM

        # The terminal emulator environment variable name
        #
        # @return [String]
        #
        # @api private
        TERMINAL_EMULATOR = "TERMINAL_EMULATOR"
        private_constant :TERMINAL_EMULATOR

        private

        # Detect JediTerm terminal
        #
        # @example
        #   jediterm.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(terminal_emulator =~ JEDITERM).nil?
        end

        # Detect any JediTerm version to support terminal hyperlinks
        #
        # @example
        #   jediterm.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          true
        end

        # Read the terminal emulator environment variable
        #
        # @example
        #   jediterm.terminal_emulator
        #   # => "JetBrains-JediTerm"
        #
        # @return [String, nil]
        #
        # @api private
        def terminal_emulator
          env[TERMINAL_EMULATOR]
        end
      end # Jediterm
    end # Terminals
  end # Link
end # TTY
