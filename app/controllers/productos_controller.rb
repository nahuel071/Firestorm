class ProductosController < ApplicationController
  before_action :get_producto, only: [:show,:destroy, :update]
  before_action :Usuario_noLogueado, only: [:create, :new]
  before_action :Usuario_noAdmin, only: [:create, :new, :edit, :update]

#Un usuario no logueado no podra subastar un producto
  def Usuario_noLogueado
     redirect_to(root_url) unless logged_in?
  end
 
 
  #Admin no podra subastar un producto
  def Usuario_noAdmin
     redirect_to(root_url) if current_usuario.admin?
  end
 
  
  def get_producto
    @producto = Producto.find(params[:id])
  end
  def index
    @productos = Producto.all
  end

  def show
   @producto=Producto.find(params[:id])
  end

  def new
    @producto = Producto.new
  end

  def create
    @producto = Producto.new(producto_params)
	@producto.usuario=current_usuario
	@producto.categoria(Categoria.find(@producto.categoria_id))

    respond_to do |format|
      if @producto.save
        format.html { redirect_to @producto, notice: 'Producto creado con exito.' }
        format.json { render :show, status: :created, location: @producto }
      else
        format.html { render :new }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
      @producto.disponible = false
         @producto.save
           flash[:success] = "Producto Eliminado"
           redirect_to producto_url
    end
  def ganador
    @producto.ofertagano_id = params[:ofertagano_id]
    @producto.save
    flash[:success] = "Ganador elegido"

  end
  private
    def producto_params
      params.require(:productos).permit(:nombre, :descripcion, :vencimiento, :prourl, :categoria_id, :ofertagano_id )
    end
end
