# frozen_string_literal: true

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the kitty terminal
      #
      # @api private
      class Kitty < Abstract
        # The kitty terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        KITTY = /kitty/i.freeze
        private_constant :KITTY

        private

        # Detect kitty terminal
        #
        # @example
        #   kitty.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term =~ KITTY).nil?
        end

        # Detect any kitty version to support terminal hyperlinks
        #
        # @example
        #   kitty.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          true
        end
      end # Kitty
    end # Terminals
  end # Link
end # TTY
