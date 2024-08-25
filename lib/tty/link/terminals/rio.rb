# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Rio terminal
      #
      # @api private
      class Rio < Abstract
        # The Rio terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        RIO = /rio/i.freeze
        private_constant :RIO

        private

        # Detect Rio terminal
        #
        # @example
        #   rio.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ RIO).nil?
        end

        # Detect whether the Rio version supports terminal hyperlinks
        #
        # @example
        #   rio.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(0, 0, 28)
        end
      end # Rio
    end # Terminals
  end # Link
end # TTY
