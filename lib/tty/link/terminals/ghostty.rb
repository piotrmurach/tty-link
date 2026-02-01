# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Ghostty terminal
      #
      # @api private
      class Ghostty < Abstract
        # The Ghostty terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        GHOSTTY = /ghostty/i.freeze
        private_constant :GHOSTTY

        private

        # Detect Ghostty terminal
        #
        # @example
        #   ghostty.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ GHOSTTY).nil?
        end

        # Detect any Ghostty terminal version to support terminal hyperlinks
        #
        # @example
        #   ghostty.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(1, 0, 0)
        end
      end # Ghostty
    end # Terminals
  end # Link
end # TTY
