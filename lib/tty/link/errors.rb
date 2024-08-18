# frozen_string_literal: true

module TTY
  class Link
    # Raised to signal an error condition
    #
    # @api public
    Error = Class.new(StandardError)

    # Raised when an abstract method is called
    #
    # @api public
    class AbstractMethodError < Error
      MESSAGE = "the %<class_name>s class must implement " \
                "the `%<method_name>s` method"

      # Create an {TTY::Link::AbstractMethodError} instance
      #
      # @example
      #   TTY::Link::AbstractMethodError.new("Terminal", "name?")
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
    end
  end # Link
end # TTY
