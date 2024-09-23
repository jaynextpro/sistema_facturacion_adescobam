class MedidoresController < ApplicationController
    # Acción para listar todos los medidores
    def index
      @medidores = Medidor.all
      @medidores = @medidores.by_keyword(params[:keyword])
      @medidores = @medidores.by_sector(params[:sector])
      @medidores = @medidores.by_activo(params[:activo])
      @medidores = @medidores.paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.csv { send_data @medidores.to_csv, filename: "medidores-#{Date.today}.csv" }
      end
    end
  
    # Acción para inicializar un nuevo medidor
    def new
      @medidor = Medidor.new
    end
  
    # Acción para editar un medidor existente
    def edit
      @medidor = Medidor.find(params[:id])
    end
  
    # Acción para crear un medidor en la base de datos
    def create
      @medidor = Medidor.new(medidor_params)
  
      if @medidor.save
        redirect_to medidores_path, notice: 'Medidor creado exitosamente.'
      else
        render :new
      end
    end
  
    # Acción para actualizar un medidor en la base de datos
    def update
      @medidor = Medidor.find(params[:id])
  
      if @medidor.update(medidor_params)
        redirect_to medidores_path, notice: 'Medidor actualizado exitosamente.'
      else
        render :edit
      end
    end
  
    # Acción para eliminar un medidor de la base de datos
    def destroy
      @medidor = Medidor.find(params[:id])
      if @medidor.destroy
        redirect_to medidores_path, notice: 'Medidor eliminado exitosamente.'
      else
        redirect_to medidores_path, alert: @medidor.errors.full_messages.to_sentence
      end
    end
  
    private
  
    # Permitir solo los parámetros permitidos
    def medidor_params
      params.require(:medidor).permit(:cliente_id, :medidor, :direccion, :sector, :activo)
    end
  end
  