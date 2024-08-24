# frozen_string_literal: true

require_relative "abstract"

module TTY
  class Link
    module Terminals
      # Responsible for detecting hyperlink support in the DomTerm terminal
      #
      # @api private
      class Domterm < Abstract
        # The domterm environment variable name
        #
        # @return [String]
        #
        # @api private
        DOMTERM = "DOMTERM"
        private_constant :DOMTERM

        # The key and value separator
        #
        # @return [String]
        #
        # @api private
        KEY_VAL_SEP = "="
        private_constant :KEY_VAL_SEP

        # The parameter separator
        #
        # @return [String]
        #
        # @api private
        PARAM_SEP = ";"
        private_constant :PARAM_SEP

        # The version parameter pattern
        #
        # @return [Regexp]
        #
        # @api private
        VERSION_PARAM = /version/i.freeze
        private_constant :VERSION_PARAM

        private

        # Detect DomTerm terminal
        #
        # @example
        #   domterm.name?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def name?
          !domterm.nil?
        end

        # Detect whether the DomTerm version supports terminal hyperlinks
        #
        # @example
        #   domterm.version?
        #   # => true
        #
        # @return [Boolean]
        #
        # @api private
        def version?
          return false unless domterm_version

          current_semantic_version = semantic_version(domterm_version)

          current_semantic_version >= semantic_version(1, 0, 2)
        end

        # Read the domterm environment variable
        #
        # @example
        #   domterm.domterm
        #   # => "version=1.2.3;tty=/dev/pts/1"
        #
        # @return [String, nil]
        #
        # @api private
        def domterm
          env[DOMTERM]
        end

        # Read the version from the domterm environment variable
        #
        # @example
        #   domterm.domterm_version
        #   # => "1.2.3"
        #
        # @return [String, nil]
        #
        # @api private
        def domterm_version
          version_pair = domterm.split(PARAM_SEP).grep(VERSION_PARAM)[0]
          return unless version_pair

          version_pair.split(KEY_VAL_SEP)[1]
        end
      end # Domterm
    end # Terminals
  end # Link
end # TTY
