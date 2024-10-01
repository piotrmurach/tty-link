# frozen_string_literal: true

module TTY
  class Link
    # Responsible for converting a URL to an ANSI-controlled terminal link
    #
    # @api private
    class ANSILink
      # The attribute separator
      #
      # @return [String]
      #
      # @api private
      ATTRIBUTE_SEPARATOR = "="
      private_constant :ATTRIBUTE_SEPARATOR

      # The attribute pair separator
      #
      # @return [String]
      #
      # @api private
      ATTRIBUTE_PAIR_SEPARATOR = ":"
      private_constant :ATTRIBUTE_PAIR_SEPARATOR

      # The bell control code
      #
      # @return [String]
      #
      # @api private
      BEL = "\a"
      private_constant :BEL

      # The hyperlink operating system command code
      #
      # @return [String]
      #
      # @api private
      OSC8 = "\e]8"
      private_constant :OSC8

      # The parameters separator
      #
      # @return [String]
      #
      # @api private
      SEP = ";"
      private_constant :SEP

      # Create an {TTY::Link::ANSILink} instance
      #
      # @example
      #   ansi_link = TTY::Link::ANSILink.new(
      #     "TTY Toolkit", "https://ttytoolkit.org", {id: "tty-toolkit"})
      #
      # @param [String] name
      #   the URL name
      # @param [String] url
      #   the URL target
      # @param [Hash{Symbol => String}] attrs
      #   the URL attributes
      #
      # @api public
      def initialize(name, url, attrs)
        @name = name
        @url = url
        @attrs = attrs
      end

      # Convert this link to an ANSI-controlled string
      #
      # @example
      #   ansi_link.to_s
      #   # => "\e]8;id=tty-toolkit;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
      #
      # @return [String]
      #
      # @api public
      def to_s
        attributes = convert_to_attributes(@attrs)
        [OSC8, SEP, attributes, SEP, @url, BEL, @name, OSC8, SEP, SEP, BEL].join
      end

      private

      # Convert the attributes hash to a string list
      #
      # @example
      #   ansi_link.convert_to_attributes(
      #     {id: "tty-toolkit", title: "TTY Toolkit"})
      #   # => "id=tty-toolkit:title=TTY Toolkit"
      #
      # @param [Hash{Symbol => String}] attrs
      #   the attributes to convert to a string list
      #
      # @return [String]
      #
      # @api private
      def convert_to_attributes(attrs)
        attrs.map do |attr_pair|
          attr_pair.join(ATTRIBUTE_SEPARATOR)
        end.join(ATTRIBUTE_PAIR_SEPARATOR)
      end
    end # ANSILink
  end # Link
end # TTY
