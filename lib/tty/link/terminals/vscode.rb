# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the VSCode terminal
      #
      # @api private
      class Vscode < Abstract
        # The VSCode terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        VSCODE = /vscode/i.freeze
        private_constant :VSCODE

        private

        # Detect VSCode terminal
        #
        # @example
        #   vscode.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ VSCODE).nil?
        end

        # Detect whether the VSCode version supports terminal hyperlinks
        #
        # @example
        #   vscode.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version = semantic_version(term_program_version)

          current_semantic_version >= semantic_version(1, 72, 0)
        end
      end # Vscode
    end # Terminals
  end # Link
end # TTY
