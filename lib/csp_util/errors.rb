# frozen_string_literal: true

module CSPUtil
  class CSPUtilError < StandardError; end

  class DirectiveError < CSPUtilError
    def initialize(directive_name)
      @directive_name = directive_name
    end
  end

  class DirectiveNameUnknown < DirectiveError
    def message
      "#{@directive_name} has been removed and is not supported"
    end
  end

  class DirectiveNameDeprecated < DirectiveError
    def message
      "directive name #{@directive_name} is unknown"
    end
  end

  class DuplicateDirective < DirectiveError
    def message
      "directive #{@directive_name} is a duplicate"
    end
  end
end
