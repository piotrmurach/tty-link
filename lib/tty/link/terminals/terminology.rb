# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Terminology terminal
      #
      # @api private
      class Terminology < Abstract
        # The Terminology terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        TERMINOLOGY = /terminology/i.freeze
        private_constant :TERMINOLOGY

        private

        # Detect Terminology terminal
        #
        # @example
        #   terminology.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ TERMINOLOGY).nil?
        end

        # Detect whether the Terminology version supports terminal hyperlinks
        #
        # @example
        #   terminology.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(1, 3, 0)
        end
      end # Terminology
    end # Terminals
  end # Link
end # TTY
