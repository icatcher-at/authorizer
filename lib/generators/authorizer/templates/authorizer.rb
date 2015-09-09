<% module_namespacing do -%>
class <%= class_name %>Authorizer < Authorizer::Base
  
  def show?
    true
  end
  alias_method :read?, :show?

  def new?
    true
  end
  alias_method :create?, :new?

  def edit?
    true
  end
  alias_method :update?, :edit?

  def destroy?
    true
  end
  alias_method :delete?, :destroy?
  
end
<% end -%>