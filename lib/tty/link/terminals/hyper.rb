# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Hyper terminal
      #
      # @api private
      class Hyper < Abstract
        # The Hyper terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        HYPER = /Hyper/i.freeze
        private_constant :HYPER

        private

        # Detect Hyper terminal
        #
        # @example
        #   hyper.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ HYPER).nil?
        end

        # Detect whether the Hyper version supports terminal hyperlinks
        #
        # @example
        #   hyper.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(2, 0, 0)
        end
      end # Hyper
    end # Terminals
  end # Link
end # TTY
