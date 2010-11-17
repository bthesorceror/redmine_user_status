require_dependency 'principal'

module PrincipalPatch
  def self.included(base)
    base.class_eval do
      unloadable
    end
  end
end
