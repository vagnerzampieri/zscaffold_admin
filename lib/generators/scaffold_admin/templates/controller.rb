<%- if namespace_name -%>
module <%= module_name %>
<%- end -%>
class <%= plural_class %>Controller < ApplicationController

  layout 'admin'
  respond_to :html, :json, :js

  def index
    @<%= plural_name %> = <%= class_name %>.order 'created_at DESC'

    respond_with @<%= plural_name %>
  end

  def show
    @<%= singular_name %> = get_register(params[:id])
    respond_with @<%= singular_name %>
  end

  def new
    @<%= singular_name %> = <%= class_name %>.new

    respond_with @<%= singular_name %>
  end

  def edit
    @<%= singular_name %> = get_register(params[:id])
    respond_with @<%= singular_name %>
  end

  def create
    @<%= singular_name %> = <%= class_name %>.new params[:<%= singular_name %>]

    if @<%= singular_name %>.save
      flash[:notice] = t :<%= singular_name %>_created
      respond_with @<%= singular_name %>
    else
      render :action => :new
    end
  end

  def update
    @<%= singular_name %> = get_register(params[:id])

    if @<%= singular_name %>.update_attributes params[:<%= singular_name %>]
      flash[:notice] = t :<%= singular_name %>_updated
      respond_with @<%= singular_name %>
    else
      render :action => :edit
    end
  end

  def destroy
    @<%= singular_name %> = get_register(params[:id])
    @<%= singular_name %>.destroy

    respond_with @<%= singular_name %>
  end

  private
    def get_register(id)
      <%= class_name %>.find(id)
    end

end
<%- if namespace_name -%>
end
<%- end -%>
