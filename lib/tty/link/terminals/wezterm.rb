# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the WezTerm terminal
      #
      # @api private
      class Wezterm < Abstract
        # The WezTerm terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        WEZTERM = /WezTerm/i.freeze
        private_constant :WEZTERM

        # The version release
        #
        # @return [String]
        #
        # @api private
        VERSION_RELEASE = "20180218"
        private_constant :VERSION_RELEASE

        # The version separator
        #
        # @return [String]
        #
        # @api private
        VERSION_SEPARATOR = "-"
        private_constant :VERSION_SEPARATOR

        private

        # Detect WezTerm terminal
        #
        # @example
        #   wezterm.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ WEZTERM).nil?
        end

        # Detect whether the WezTerm version supports terminal hyperlinks
        #
        # @example
        #   wezterm.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless term_program_version

          current_semantic_version =
            semantic_version(term_program_version, separator: VERSION_SEPARATOR)

          current_semantic_version >= semantic_version(VERSION_RELEASE, 0, 0)
        end
      end # Wezterm
    end # Terminals
  end # Link
end # TTY
