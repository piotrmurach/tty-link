# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the VTE-based terminal
      #
      # @api private
      class Vte < Abstract
        # The VTE version environment variable name
        #
        # @return [String]
        #
        # @api private
        VTE_VERSION = "VTE_VERSION"
        private_constant :VTE_VERSION

        private

        # Detect VTE terminal
        #
        # @example
        #   vte.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !vte_version.nil?
        end

        # Detect whether the VTE version supports terminal hyperlinks
        #
        # @example
        #   vte.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          current_semantic_version = semantic_version(vte_version)

          current_semantic_version >= semantic_version(0, 50, 1)
        end

        # Read the VTE version environment variable
        #
        # @example
        #   vte.vte_version
        #   # => "5100"
        #
        # @return [String, nil]
        #
        # @api private
        def vte_version
          env[VTE_VERSION]
        end
      end # Vte
    end # Terminals
  end # Link
end # TTY
