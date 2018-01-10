# frozen_string_literal: true

module CSPUtil
  class << self
    def parse_directives(serialized_policy)
      tokens = serialized_policy.split(';')

      tokens.each_with_object([]) do |token, directives|
        token.strip!
        next if token.empty?

        directive = Directive.new(token)
        validate_uniqueness!(directive, directives)

        directives << directive
      end
    end

    private

    def validate_uniqueness!(directive, directives)
      return if directives.none? { |d| d.same_name?(directive) }

      raise(DuplicateDirective, directive.name)
    end
  end
end
