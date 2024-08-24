# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Foot terminal
      #
      # @api private
      class Foot < Abstract
        # The Foot terminal name pattern
        #
        # @return [Regexp]
        #
        # @api private
        FOOT = /foot/i.freeze
        private_constant :FOOT

        private

        # Detect Foot terminal
        #
        # @example
        #   foot.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !(term =~ FOOT).nil?
        end

        # Detect any Foot version to support terminal hyperlinks
        #
        # @example
        #   foot.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          true
        end
      end # Foot
    end # Terminals
  end # Link
end # TTY
