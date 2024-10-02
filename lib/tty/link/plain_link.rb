# frozen_string_literal: true

module TTY
  class Link
    # Responsible for converting a URL to a plain terminal link
    #
    # @api private
    class PlainLink
      # The replacement tokens pattern
      #
      # @return [Regexp]
      #
      # @api private
      REPLACEMENT_TOKENS_PATTERN = /:(name|url)/i.freeze
      private_constant :REPLACEMENT_TOKENS_PATTERN

      # Create a {TTY::Link::PlainLink} instance
      #
      # @example
      #   plain_link = TTY::Link::PlainLink.new(
      #     "TTY Toolkit", "https://ttytoolkit.org", ":name (:url)")
      #
      # @param [String] name
      #   the URL name
      # @param [String] url
      #   the URL target
      # @param [String] template
      #   the URL replacement template
      #
      # @api public
      def initialize(name, url, template)
        @name = name
        @url = url
        @template = template
      end

      # Convert this link to a plain string
      #
      # @example
      #   plain_link.to_s
      #   # => "TTY Toolkit (https://ttytoolkit.org)"
      #
      # @return [String]
      #
      # @api public
      def to_s
        replacements = {":name" => @name, ":url" => @url}
        @template.gsub(REPLACEMENT_TOKENS_PATTERN, replacements)
      end
    end # PlainLink
  end # Link
end # TTY
