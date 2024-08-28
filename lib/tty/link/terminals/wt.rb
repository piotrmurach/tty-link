# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the Windows Terminal
      #
      # @api private
      class Wt < Abstract
        # The wt session environment variable name
        #
        # @return [String]
        #
        # @api private
        WT_SESSION = "WT_SESSION"
        private_constant :WT_SESSION

        private

        # Detect Windows Terminal
        #
        # @example
        #   wt.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !wt_session.nil?
        end

        # Detect any Windows Terminal version to support terminal hyperlinks
        #
        # @example
        #   wt.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          true
        end

        # Read the wt session environment variable
        #
        # @example
        #   wt.wt_session
        #   # => "the-unique-identifier"
        #
        # @return [String, nil]
        #
        # @api private
        def wt_session
          env[WT_SESSION]
        end
      end # Wt
    end # Terminals
  end # Link
end # TTY
