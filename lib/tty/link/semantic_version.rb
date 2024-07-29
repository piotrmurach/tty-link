# frozen_string_literal: true

module TTY
  class Link
    # Responsible for comparing terminal release versions
    #
    # @api private
    class SemanticVersion
      include Comparable

      # The unseparated version pattern
      #
      # @return [Regexp]
      #
      # @api private
      UNSEPARATED_VERSION_PATTERN = /^(\d{1,2})(\d{2})$/.freeze
      private_constant :UNSEPARATED_VERSION_PATTERN

      # The version separator
      #
      # @return [String]
      #
      # @api private
      VERSION_SEPARATOR = "."
      private_constant :VERSION_SEPARATOR

      # The zero number
      #
      # @return [String]
      #
      # @api private
      ZERO_NUMBER = "0"
      private_constant :ZERO_NUMBER

      # Create a {TTY::Link::SemanticVersion} instance from a version value
      #
      # @example
      #   TTY::Link::SemanticVersion.from(1, 2, 3)
      #
      # @example
      #   TTY::Link::SemanticVersion[1, 2, 3]
      #
      # @example
      #   TTY::Link::SemanticVersion.from("1234")
      #
      # @example
      #   TTY::Link::SemanticVersion.from("1.2.3")
      #
      # @example
      #   TTY::Link::SemanticVersion.from("1-2-3", separator: "-")
      #
      # @param [Array<Integer, String>] version
      #   the version to convert to a semantic version
      # @param [String] separator
      #   the version separator
      #
      # @return [TTY::Link::SemanticVersion]
      #
      # @api public
      def self.from(*version, separator: VERSION_SEPARATOR)
        major, minor, patch =
          if version.size == 1 && version[0].respond_to?(:split)
            convert_to_array(version[0], separator: separator)
          else
            version
          end
        new(major.to_i, minor.to_i, patch.to_i)
      end
      singleton_class.send(:alias_method, :[], :from)

      # Convert a string version to an array
      #
      # @example
      #   TTY::Link::SemanticVersion.from("1234")
      #   # => ["0", "12", "34"]
      #
      # @example
      #   TTY::Link::SemanticVersion.convert_to_array("1.2.3")
      #   # => ["1", "2", "3"]
      #
      # @example
      #   TTY::Link::SemanticVersion.convert_to_array("1-2-3", separator: "-")
      #   # => ["1", "2", "3"]
      #
      # @param [String] version
      #   the version to convert to an array
      # @param [String] separator
      #   the version separator
      #
      # @return [Array<String>]
      #
      # @api private
      def self.convert_to_array(version, separator: VERSION_SEPARATOR)
        if (matches = version.match(UNSEPARATED_VERSION_PATTERN))
          [ZERO_NUMBER, matches[1], matches[2]]
        else
          version.split(separator)
        end
      end
      private_class_method :convert_to_array

      # The major number
      #
      # @example
      #   semantic_version.major
      #
      # @return [Integer]
      #
      # @api public
      attr_reader :major

      # The minor number
      #
      # @example
      #   semantic_version.minor
      #
      # @return [Integer]
      #
      # @api public
      attr_reader :minor

      # The patch number
      #
      # @example
      #   semantic_version.patch
      #
      # @return [Integer]
      #
      # @api public
      attr_reader :patch

      # Create a {TTY::Link::SemanticVersion} instance
      #
      # @example
      #   TTY::Link::SemanticVersion.new(1, 2, 3)
      #
      # @param [Integer] major
      #   the major number
      # @param [Integer] minor
      #   the minor number
      # @param [Integer] patch
      #   the patch number
      #
      # @api private
      def initialize(major, minor, patch)
        @major = major
        @minor = minor
        @patch = patch
      end
      private_class_method :new

      # Compare this semantic version with another object
      #
      # @example
      #   semantic_version >= other
      #
      # @param [Object] other
      #   the other object to compare with
      #
      # @return [Integer, nil]
      #   Return negative, zero, or positive number when
      #   this semantic version is less than, equal to, or
      #   greater than other semantic version. Return nil
      #   when the other object is not a semantic version.
      #
      # @api public
      def <=>(other)
        return unless other.is_a?(self.class)

        major_comparison = @major <=> other.major
        return major_comparison unless major_comparison.zero?

        minor_comparison = @minor <=> other.minor
        return minor_comparison unless minor_comparison.zero?

        @patch <=> other.patch
      end

      # Generate hash value for this semantic version
      #
      # @example
      #   semantic_version.hash
      #
      # @return [Integer]
      #
      # @api public
      def hash
        [self.class, @major, @minor, @patch].hash
      end

      # Convert this semantic version to a string
      #
      # @example
      #   semantic_version.inspect
      #
      # @return [String]
      #
      # @api public
      def inspect
        [@major, @minor, @patch].join(VERSION_SEPARATOR)
      end
    end # SemanticVersion
  end # Link
end # TTY
