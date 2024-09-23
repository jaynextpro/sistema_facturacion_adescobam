require 'csv'

class Factura < ApplicationRecord
  include ReusableFunctions
  belongs_to :medidor, optional: true
  belongs_to :periodo, foreign_key: :periodo_id, optional: true
  belongs_to :cliente, optional: true

  validates :medidor, presence: true
  validates :periodo, presence: true
  # validates :numero_factura, presence: true, uniqueness: true
  validates :fecha_emision, presence: true
  validates :lectura_anterior_metros_cubicos, presence: true
  validates :lectura_actual_metros_cubicos, presence: true
  validates :consumo_metros_cubicos, presence: true
  validates :valor_por_metro_cubico, presence: true
  validates :cargo_total, presence: true
  # validates :cargo_total_facturas_pendientes, presence: true
  # validates :cuota_social_pendiente, presence: true
  validates :fecha_vencimiento, presence: true
  validates :recargo_despues_vencimiento, presence: true
  validates :cargo_total_despues_vencimiento, presence: true

  validates :periodo, uniqueness: { scope: :medidor, message: "ya existe una factura con esta información mensual y medidor" }

  before_validation :set_valores, :set_numero_factura

  default_scope { where(eliminada: false) }

  scope :by_cancelado, ->(cancelado) { where(cancelado: cancelado) unless cancelado.blank? }
  scope :by_mes, ->(mes) { joins(:periodo).where('periodos.mes = ?', mes) unless mes.blank? }
  scope :by_año, ->(año) { joins(:periodo).where('periodos.año = ?', año) unless año.blank? }
  scope :by_sector, ->(sector) {
    return all if sector.blank?
    joins(:medidor).where(medidores: { sector: sector })
  }
  scope :by_keyword, ->(keyword) {
  joins(:medidor, :cliente)
    .where(
      'REPLACE(clientes.dui, \'-\', \'\') ILIKE :keyword OR numero_factura ILIKE :keyword OR medidores.medidor ILIKE :keyword OR clientes.nombre_completo ILIKE :keyword',
      keyword: "%#{keyword&.strip&.gsub('-', '')}%"
    )
  }

  # Add methods for formatted date and datetime attributes
  def fecha_emision_with_format
    fecha_emision.strftime("%d/%m/%Y") if fecha_emision.present?
  end

  def fecha_vencimiento_with_format
    fecha_vencimiento.strftime("%d/%m/%Y") if fecha_vencimiento.present?
  end

  def fecha_pago_with_format
    fecha_pago.strftime("%d/%m/%Y") if fecha_pago.present?
  end

  def created_at_with_format
    created_at.strftime("%d/%m/%Y %H:%M") if created_at.present?
  end

  def updated_at_with_format
    updated_at.strftime("%d/%m/%Y %H:%M") if updated_at.present?
  end

  def self.to_csv
    headers = [
      "ID", "Numero Factura", "Medidor ID", "Periodo ID", "Cliente ID", "Fecha Emision", 
      "Lectura Anterior Metros Cubicos", "Lectura Actual Metros Cubicos", "Consumo Metros Cubicos", 
      "Valor Por Metro Cubico", "Cargo Total", "Cargo Total Facturas Pendientes", 
      "Cuota Social Pendiente", "Fecha Vencimiento", "Recargo Despues De Vencimiento", 
      "Cargo Total Despues De Vencimiento", "Cancelado", "Fecha Pago", "Monto Total Pagado", 
      "Observaciones", "Creado", "Actualizado"
    ]

    attributes = %w{
      id numero_factura medidor_id periodo_id cliente_id fecha_emision_with_format
      lectura_anterior_metros_cubicos lectura_actual_metros_cubicos consumo_metros_cubicos
      valor_por_metro_cubico cargo_total cargo_total_facturas_pendientes
      cuota_social_pendiente fecha_vencimiento_with_format recargo_despues_vencimiento
      cargo_total_despues_vencimiento estado_string fecha_pago_with_format monto_total_pagado
      observaciones created_at_with_format updated_at_with_format
    }

    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |factura|
        csv << attributes.map{ |attr| factura.send(attr) }
      end
    end
  end

  def emision_mes_texto
    mes_to_text(fecha_emision.try(:month))
  end

  def vencimiento_mes_texto
    mes_to_text(fecha_vencimiento.try(:month))
  end

  def estado_string
    cancelado ? 'SI' : 'NO'
  end

  def destroy 
    self.update_columns(eliminada: true)
  end

  private

  def set_numero_factura 
    last_factura = Factura.first
    if last_factura.present? and self.new_record?
      last_numero = last_factura.numero_factura.to_i
      new_numero = (last_numero >= 9999 ? 1 : last_numero + 1).to_s.rjust(4, '0')
    else
      new_numero = '0001'
    end
    
    self.numero_factura = new_numero if self.new_record?
  end

  def set_valores
    self.cliente_id = medidor.cliente_id if medidor.present?
    self.consumo_metros_cubicos = lectura_actual_metros_cubicos - lectura_anterior_metros_cubicos if lectura_actual_metros_cubicos.present? && lectura_anterior_metros_cubicos.present?
    self.cargo_total = consumo_metros_cubicos * valor_por_metro_cubico if consumo_metros_cubicos.present? && valor_por_metro_cubico.present?
    self.recargo_despues_vencimiento = cargo_total * 0.05 if consumo_metros_cubicos.present? && valor_por_metro_cubico.present?
    self.cuota_social_pendiente = 0 if cuota_social_pendiente.blank?
    self.cargo_total_facturas_pendientes = 0 if cargo_total_facturas_pendientes.blank?
    self.cargo_total_despues_vencimiento = cargo_total_facturas_pendientes + cargo_total + recargo_despues_vencimiento if cargo_total_facturas_pendientes.present? && cargo_total.present? && recargo_despues_vencimiento.present?
  end
end
