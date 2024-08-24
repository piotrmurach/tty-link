# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Contour terminal
      #
      # @api private
      class Contour < Abstract
        # The Contour terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        CONTOUR = /contour/i.freeze
        private_constant :CONTOUR

        # The terminal name environment variable name
        #
        # @return [String]
        #
        # @api private
        TERMINAL_NAME = "TERMINAL_NAME"
        private_constant :TERMINAL_NAME

        # The terminal version triple environment variable name
        #
        # @return [String]
        #
        # @api private
        TERMINAL_VERSION_TRIPLE = "TERMINAL_VERSION_TRIPLE"
        private_constant :TERMINAL_VERSION_TRIPLE

        private

        # Detect Contour terminal
        #
        # @example
        #   contour.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(terminal_name =~ CONTOUR).nil?
        end

        # Detect whether the Contour version supports terminal hyperlinks
        #
        # @example
        #   contour.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless terminal_version_triple

          current_semantic_version = semantic_version(terminal_version_triple)

          current_semantic_version >= semantic_version(0, 1, 0)
        end

        # Read the terminal name environment variable
        #
        # @example
        #   contour.terminal_name
        #   # => "contour"
        #
        # @return [String, nil]
        #
        # @api private
        def terminal_name
          env[TERMINAL_NAME]
        end

        # Read the terminal version triple environment variable
        #
        # @example
        #   contour.terminal_version_triple
        #   # => "1.2.3"
        #
        # @return [String, nil]
        #
        # @api private
        def terminal_version_triple
          env[TERMINAL_VERSION_TRIPLE]
        end
      end # Contour
    end # Terminals
  end # Link
end # TTY
