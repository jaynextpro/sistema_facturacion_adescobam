class ClientesController < ApplicationController
    # Acción para listar todos los clientes
    def index
      @clientes = Cliente.all
      @clientes = @clientes.by_keyword(params[:keyword]).paginate(page: params[:page], per_page: 10)
      @clientes = @clientes.paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.csv { send_data @clientes.to_csv, filename: "clientes-#{Date.today}.csv" }
      end
    end
  
    # Acción para inicializar un nuevo cliente
    def new
      @cliente = Cliente.new
    end
  
    # Acción para editar un cliente existente
    def edit
      @cliente = Cliente.find(params[:id])
    end
  
    # Acción para crear un cliente en la base de datos
    def create
      @cliente = Cliente.new(cliente_params)
  
      if @cliente.save
        redirect_to clientes_path, notice: 'Cliente creado exitosamente.'
      else
        render :new
      end
    end
  
    # Acción para actualizar un cliente en la base de datos
    def update
      @cliente = Cliente.find(params[:id])
  
      if @cliente.update(cliente_params)
        redirect_to clientes_path, notice: 'Cliente actualizado exitosamente.'
      else
        render :edit
      end
    end
  
    # Acción para eliminar un cliente de la base de datos
    def destroy
      @cliente = Cliente.find(params[:id])
      if @cliente.destroy
        redirect_to clientes_path, notice: 'Medidor eliminado exitosamente.'
      else
        redirect_to clientes_path, alert: @cliente.errors.full_messages.to_sentence
      end
    end
  
    private
  
    # Permitir solo los parámetros permitidos
    def cliente_params
      params.require(:cliente).permit(:dui, :nombre_completo)
    end
  end
  