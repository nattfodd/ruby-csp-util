# frozen_string_literal: true

module CSPUtil
  class << self
    def join_directives(directives)
      directives.map(&:to_s).join('; ')
    end
  end
end
