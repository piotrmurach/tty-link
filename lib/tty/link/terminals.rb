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
        end
      end
      private_class_method :require_all

      require_all
    end # Terminals
  end # Link
end # TTY
