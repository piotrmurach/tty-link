# frozen_string_literal: true

require_relative "error"

module TTY
  class Link
    # Raised when a class does not implement an abstract method
    #
    # @api public
    class AbstractMethodError < Error
      # The error message template
      #
      # @return [String]
      #
      # @api private
      MESSAGE = "the %<class_name>s class must implement " \
                "the %<method_name>s method."
      private_constant :MESSAGE

      # Create a {TTY::Link::AbstractMethodError} instance
      #
      # @example
      #   TTY::Link::AbstractMethodError.new("Terminal", :name?)
      #
      # @param [String] class_name
      #   the class name
      # @param [Symbol] method_name
      #   the method name
      #
      # @api private
      def initialize(class_name, method_name)
        super(format(MESSAGE, class_name: class_name, method_name: method_name))
      end
    end # AbstractMethodError
  end # Link
end # TTY
