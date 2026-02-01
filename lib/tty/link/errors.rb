# frozen_string_literal: true

module TTY
  class Link
    # Raised to signal an error condition
    #
    # @api public
    class Error < StandardError
    end # Error

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

    # Raised when a parameter value doesn't match the allowed values
    #
    # @api public
    class ValueError < Error
      # The error message template
      #
      # @return [String]
      #
      # @api private
      MESSAGE = "invalid value for the %<param_name>s parameter: " \
                "%<invalid_value>s.\nMust be one of: %<allowed_values>s."
      private_constant :MESSAGE

      # The allowed values separator
      #
      # @return [String]
      #
      # @api private
      VALUES_SEPARATOR = ", "
      private_constant :VALUES_SEPARATOR

      # Create a {TTY::Link::ValueError} instance
      #
      # @example
      #   TTY::Link::ValueError.new(:name, :invalid, %i[valid_a valid_b])
      #
      # @param [Symbol] param_name
      #   the parameter name
      # @param [Object] invalid_value
      #   the invalid value
      # @param [Array] allowed_values
      #   the allowed values
      #
      # @api private
      def initialize(param_name, invalid_value, allowed_values)
        super(format(
          MESSAGE,
          param_name: param_name.inspect,
          invalid_value: invalid_value.inspect,
          allowed_values: allowed_values.map(&:inspect).join(VALUES_SEPARATOR)
        ))
      end
    end # ValueError
  end # Link
end # TTY
