# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Tabby terminal
      #
      # @api private
      class Tabby < Abstract
        # The Tabby terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        TABBY = /Tabby/i.freeze
        private_constant :TABBY

        private

        # Detect Tabby terminal
        #
        # @example
        #   tabby.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term_program =~ TABBY).nil?
        end

        # Detect any Tabby version to support terminal hyperlinks
        #
        # @example
        #   tabby.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          true
        end
      end # Tabby
    end # Terminals
  end # Link
end # TTY
