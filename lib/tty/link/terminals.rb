# frozen_string_literal: true

module TTY
  class Link
    # Responsible for loading terminals
    #
    # @api private
    module Terminals
      # The directory name for terminals
      #
      # @return [String]
      #
      # @api private
      DIR_NAME = "terminals"
      private_constant :DIR_NAME

      # The Ruby file pattern
      #
      # @return [String]
      #
      # @api private
      RUBY_FILE = "*.rb"
      private_constant :RUBY_FILE

      # Require all terminal files from the terminals directory
      #
      # @example
      #   TTY::Link::Terminals.require_terminals
      #
      # @return [void]
      #
      # @api private
      def self.require_terminals
        terminals_dir = ::File.join(__dir__, DIR_NAME, RUBY_FILE)
        ::Dir.glob(terminals_dir).sort.each do |terminal_path|
          require_relative ::File.join(DIR_NAME, ::File.basename(terminal_path))
        end
      end
      private_class_method :require_terminals

      require_terminals
    end
  end # Link
end # TTY
