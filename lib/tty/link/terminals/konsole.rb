# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Konsole terminal
      #
      # @api private
      class Konsole < Abstract
        # The Konsole version environment variable name
        #
        # @return [String]
        #
        # @api private
        KONSOLE_VERSION = "KONSOLE_VERSION"
        private_constant :KONSOLE_VERSION

        private

        # Detect Konsole terminal
        #
        # @example
        #   konsole.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !konsole_version.nil?
        end

        # Detect whether the Konsole version supports terminal hyperlinks
        #
        # @example
        #   konsole.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          current_semantic_version = semantic_version(konsole_version)

          current_semantic_version >= semantic_version(20, 12, 0)
        end

        # Read the Konsole version environment variable
        #
        # @example
        #   konsole.konsole_version
        #   # => "1.2.3"
        #
        # @return [String, nil]
        #
        # @api private
        def konsole_version
          env[KONSOLE_VERSION]
        end
      end # Konsole
    end # Terminals
  end # Link
end # TTY
