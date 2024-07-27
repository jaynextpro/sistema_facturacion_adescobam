class PeriodosController < ApplicationController
    # Acción para listar todas los periodos
    def index
      @periodos = Periodo.all.paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.csv { send_data @periodos.to_csv, filename: "periodos-#{Date.today}.csv" }
      end
    end
  
    # Acción para inicializar un nueva Periodo
    def new
      @periodo = Periodo.new
    end
  
    # Acción para editar un Periodo existente
    def edit
      @periodo = Periodo.find(params[:id])
    end
  
    # Acción para crear un Periodo en la base de datos
    def create
      @periodo = Periodo.new(periodo_params)
  
      if @periodo.save
        redirect_to periodos_path, notice: 'Periodo creado exitosamente.'
      else
        render :new
      end
    end
  
    # Acción para actualizar un Periodo en la base de datos
    def update
      @periodo = Periodo.find(params[:id])
  
      if @periodo.update(periodo_params)
        redirect_to periodos_path, notice: 'Periodo actualizado exitosamente.'
      else
        render :edit
      end
    end
  
    # Acción para eliminar un Periodo de la base de datos
    def destroy
      @periodo = Periodo.find(params[:id])
      if @periodo.destroy
        redirect_to periodos_path, notice: 'Medidor eliminado exitosamente.'
      else
        redirect_to periodos_path, alert: @periodo.errors.full_messages.to_sentence
      end
    end
  
    private
  
    # Permitir solo los parámetros permitidos
    def periodo_params
      params.require(:periodo).permit(:mes, :año, :fecha_asamblea)
    end
  end
  