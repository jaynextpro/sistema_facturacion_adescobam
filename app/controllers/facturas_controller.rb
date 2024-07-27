class FacturasController < ApplicationController
    # Acción para listar todas las facturas
    def index
      @facturas = (params[:unscoped].present? && params[:unscoped] == "true") ? Factura.unscoped.all.order(created_at: :desc) : Factura.all
      @facturas = @facturas.paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.csv { send_data @facturas.to_csv, filename: "facturas-#{Date.today}.csv" }
      end
    end

    def print_facturas
      facturas_ids = params[:facturas_ids]
  
      if facturas_ids.present?
        @facturas = (params[:unscoped].present? && params[:unscoped] == "true") ? Factura.unscoped.order(created_at: :desc).where(id: facturas_ids) : Factura.all.where(id: facturas_ids)
  
        respond_to do |format|
          format.html do
            pdf_html = render_to_string(
              template: "home/facturas",
              encoding: 'UTF-8',
              layout: false
            )
            pdf = WickedPdf.new.pdf_from_string(pdf_html)
  
            send_data pdf,
                      filename: "facturas.pdf",
                      type: 'application/pdf',
                      disposition: 'attachment'
          end
        end
      else
        flash[:alert] = 'No se seleccionaron facturas.'
        redirect_to facturas_path(unscoped: params[:unscoped])
      end
    end

    # Acción para inicializar una nueva factura
    def new
      @factura = Factura.new
    end
  
    # Acción para editar una factura existente
    def edit
      @factura = Factura.unscoped.find(params[:id])
    end
  
    # Acción para crear una factura en la base de datos
    def create
      @factura = Factura.new(factura_params)
  
      if @factura.save
        redirect_to facturas_path, notice: 'Factura creada exitosamente.'
      else
        render :new
      end
    end
  
    # Acción para actualizar una factura en la base de datos
    def update
      @factura = Factura.unscoped.find(params[:id])
  
      if @factura.update(factura_params)
        redirect_to facturas_path, notice: 'Factura actualizada exitosamente.'
      else
        render :edit
      end
    end
  
    # Acción para eliminar una factura de la base de datos
    def destroy
      @factura = Factura.find(params[:id])
      @factura.destroy
      redirect_to facturas_path(unscoped: params[:unscoped]), notice: 'Factura eliminada exitosamente.'
    end

    def restaurar
      @factura = Factura.unscoped.find(params[:id])
      @factura.update_columns(eliminada: false)
      redirect_to facturas_path(unscoped: params[:unscoped]), notice: 'Factura restaurada exitosamente.'
    end
  
    private
  
    # Permitir solo los parámetros permitidos
    def factura_params
      params.require(:factura).permit(
        :medidor_id, :periodo_id, :cliente_id, :numero_factura, :fecha_emision,
        :lectura_anterior_metros_cubicos, :lectura_actual_metros_cubicos, :consumo_metros_cubicos,
        :valor_por_metro_cubico, :cargo_total, :fecha_pago, :monto_total_pagado, :cargo_total_facturas_pendientes,
        :cuota_social_pendiente, :fecha_vencimiento, :recargo_despues_vencimiento,
        :cargo_total_despues_vencimiento, :observaciones
      )
    end
  end
  