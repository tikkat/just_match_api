# frozen_string_literal: true
class HourlyPayPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.active
    end
  end

  def index?
    true
  end
end
