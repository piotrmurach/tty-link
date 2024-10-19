# frozen_string_literal: true

module TTY
  class Link
    # Responsible for representing hyperlink parameter value
    #
    # @api private
    class HyperlinkParameter
      # The allowed parameter values
      #
      # @return [Array<String>]
      #
      # @api private
      ALLOWED_VALUES = %w[always auto never].freeze
      private_constant :ALLOWED_VALUES

      # Create a {TTY::Link::HyperlinkParameter} instance
      #
      # @example
      #   hyperlink_parameter = TTY::Link::HyperlinkParameter.new(:always)
      #
      # @param [String, Symbol] value
      #   the parameter value
      #
      # @raise [TTY::Link::ValueError]
      #   the value isn't always, auto or never
      #
      # @api public
      def initialize(value)
        @value = validate(value).to_sym
      end

      # Check whether this parameter value is always
      #
      # @example
      #   hyperlink_parameter.always?
      #   # => true
      #
      # @return [Boolean]
      #
      # @api public
      def always?
        @value == :always
      end

      # Check whether this parameter value is auto
      #
      # @example
      #   hyperlink_parameter.auto?
      #   # => false
      #
      # @return [Boolean]
      #
      # @api public
      def auto?
        @value == :auto
      end

      # Check whether this parameter value is never
      #
      # @example
      #   hyperlink_parameter.never?
      #   # => false
      #
      # @return [Boolean]
      #
      # @api public
      def never?
        @value == :never
      end

      private

      # Validate this parameter value
      #
      # @example
      #   hyperlink_parameter.validate(:invalid)
      #
      # @param [Object] value
      #   the value to validate
      #
      # @return [String, Symbol]
      #
      # @raise [TTY::Link::ValueError]
      #   the value isn't always, auto or never
      #
      # @api private
      def validate(value)
        return value if ALLOWED_VALUES.include?(value.to_s)

        raise ValueError.new(:hyperlink, value, ALLOWED_VALUES.map(&:to_sym))
      end
    end # HyperlinkParameter
  end # Link
end # TTY
