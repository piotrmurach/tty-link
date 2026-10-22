# frozen_string_literal: true

module TTY
  class Link
    # Responsible for loading terminals
    #
    # @api private
    module Terminals
      # The terminal names
      #
      # @return [Array<String>]
      #
      # @api private
      NAMES = %w[
        alacritty
        contour
        domterm
        foot
        hyper
        iterm
        jediterm
        kitty
        konsole
        mintty
        rio
        tabby
        terminology
        vscode
        vte
        wezterm
        wt
      ].freeze
      private_constant :NAMES

      # List the terminal classes
      #
      # @example
      #   TTY::Link::Terminals.list { |terminal_class| ... }
      #
      # @yieldparam [Class<TTY::Link::Terminals::Abstract>] terminal_class
      #   the terminal class
      #
      # @return [Array]
      #
      # @api public
      def self.list
        NAMES.map do |name|
          yield const_get(name.capitalize)
        end
      end

      # The registered terminal classes
      #
      # @example
      #   TTY::Link::Terminals.registered
      #
      # @return [Array<TTY::Link::Terminals::Abstract>]
      #
      # @api private
      def self.registered
        @registered ||= []
      end

      # Register a terminal class
      #
      # @example
      #   TTY::Link::Terminals.register(TTY::Link::Terminals::Iterm)
      #
      # @param [TTY::Link::Terminals::Abstract] terminal_class
      #   the terminal class to register
      #
      # @return [void]
      #
      # @api private
      def self.register(terminal_class)
        registered << terminal_class
      end

      # Require all terminal files
      #
      # @example
      #   TTY::Link::Terminals.require_all
      #
      # @return [void]
      #
      # @api private
      def self.require_all
        NAMES.each do |name|
          require_relative "terminals/#{name}"
          register(const_get(name.capitalize))
        end
      end
      private_class_method :require_all

      require_all
    end # Terminals
  end # Link
end # TTY
