# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the mintty terminal
      #
      # @api private
      class Mintty < Abstract
        # The mintty terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        MINTTY = /mintty/i.freeze
        private_constant :MINTTY

        private

        # Detect mintty terminal
        #
        # @example
        #   mintty.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ MINTTY).nil?
        end

        # Detect whether the mintty version supports terminal hyperlinks
        #
        # @example
        #   mintty.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(2, 9, 7)
        end
      end # Mintty
    end # Terminals
  end # Link
end # TTY
