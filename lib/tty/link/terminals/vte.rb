# frozen_string_literal: true

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the VTE-based terminal
      #
      # @api private
      class Vte
        # The VTE version environment variable name
        #
        # @return [String]
        #
        # @api private
        VTE_VERSION = "VTE_VERSION"
        private_constant :VTE_VERSION

        # Create an {TTY::Link::Terminals::Vte} instance
        #
        # @example
        #   vte = TTY::Link::Terminals::Vte.new(SemanticVersion, ENV)
        #
        # @param [TTY::Link::SemanticVersion] semantic_version
        #   the semantic version creator
        # @param [ENV, Hash{String => String}] env
        #   the environment variables
        #
        # @api public
        def initialize(semantic_version, env)
          @semantic_version = semantic_version
          @env = env
        end

        # Detect VTE hyperlink support
        #
        # @example
        #   vte.link?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api public
        def link?
          name? && version?
        end

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

        # Create a {TTY::Link::SemanticVersion} instance from a version value
        #
        # @example
        #   vte.semantic_version(1, 2, 3)
        #
        # @example
        #   vte.semantic_version("1.2.3")
        #
        # @param [Array<Integer, String>] version
        #   the version to convert to a semantic version
        # @param [Hash{Symbol => String}] options
        #   the options to convert to a semantic version
        # @option options [String] :separator
        #   the version separator
        #
        # @return [TTY::Link::SemanticVersion]
        #
        # @see SemanticVersion#from
        #
        # @api private
        def semantic_version(*version, **options)
          @semantic_version.from(*version, **options)
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
          @env[VTE_VERSION]
        end
      end # Vte
    end # Terminals
  end # Link
end # TTY
