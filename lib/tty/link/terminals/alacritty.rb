# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Alacritty terminal
      #
      # @api private
      class Alacritty < Abstract
        # The Alacritty terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        ALACRITTY = /alacritty/i.freeze
        private_constant :ALACRITTY

        # The term environment variable name
        #
        # @return [String]
        #
        # @api private
        TERM = "TERM"
        private_constant :TERM

        private

        # Detect Alacritty terminal
        #
        # @example
        #   alacritty.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term =~ ALACRITTY).nil?
        end

        # Detect any Alacritty version to support terminal hyperlinks
        #
        # @example
        #   alacritty.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          true
        end

        # Read the term environment variable
        #
        # @example
        #   alacritty.term
        #   # => "alacritty"
        #
        # @return [String, nil]
        #
        # @api private
        def term
          env[TERM]
        end
      end # Alacritty
    end # Terminals
  end # Link
end # TTY
