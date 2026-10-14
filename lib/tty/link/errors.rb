# frozen_string_literal: true

require_relative "abstract_method_error"

module TTY
  class Link
    # Raised when a parameter value is not one of the allowed values
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
