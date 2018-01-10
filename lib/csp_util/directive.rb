# frozen_string_literal: true

module CSPUtil
  class Directive
    # More info:
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
    VALID_NAMES =
      %w[
        child-src connect-src default-src font-src frame-src img-src
        manifest-src media-src object-src script-src style-src worker-src
        base-uri plugin-types sandbox disown-opener form-action frame-ancestors
        report-uri report-to upgrade-insecure-requests block-all-mixed-content
        require-sri-for
      ].freeze
    DEPRECATED_NAMES = %w[reflected-xss referrer].freeze
    FULLY_DEPRECATED_NAMES = %w[policy-uri].freeze

    attr_reader :name, :value

    def initialize(token)
      dir_name, dir_value = token.split(' ', 2)
      validate_name!(dir_name)

      @name  = dir_name
      @value =
        if dir_value
          dir_value.split(' ').map(&:strip)
        else
          []
        end
    end

    def same_name?(another_directive)
      return false unless name

      name.casecmp(another_directive.name).zero?
    end

    def to_h
      { name: name, value: value }
    end

    private

    def validate_name!(directive_name)
      return unless directive_name

      name = directive_name.downcase
      return if VALID_NAMES.include?(name)
      # Show warning for deprecated names?
      return if DEPRECATED_NAMES.include?(name)

      if FULLY_DEPRECATED_NAMES.include?(name)
        raise(DirectiveNameDeprecated, directive_name)
      end

      raise(DirectiveNameUnknown, directive_name)
    end
  end
end
