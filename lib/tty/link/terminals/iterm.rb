# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the iTerm terminal
      #
      # @api private
      class Iterm < Abstract
        # The iTerm terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        ITERM = /iTerm(\s*\d+){0,1}.app/x.freeze
        private_constant :ITERM

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
      end # Iterm
    end # Terminals
  end # Link
end # TTY
