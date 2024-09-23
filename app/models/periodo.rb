require 'csv'

class Periodo < ApplicationRecord
  include ReusableFunctions

  has_many :facturas, dependent: :restrict_with_error
  
  validates :mes, presence: true,
                  numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12, message: "debe ser un número entre 1 y 12" }
  validates :año, presence: true,
                  numericality: { only_integer: true, greater_than: 0, message: "debe ser un año válido" }
  
  validates :mes, uniqueness: { scope: :año, message: "ya existe para este año" }

  validates :fecha_asamblea, presence: true

  scope :by_mes, ->(mes) { where('mes = ?', mes) unless mes.blank? }
  scope :by_año, ->(año) { where('año = ?', año) unless año.blank? }

  def titulo 
    "#{mes_texto} - #{año}"
  end

  # Add methods for formatted date and datetime attributes
  def fecha_asamblea_with_format
    fecha_asamblea.strftime("%d/%m/%Y %H:%M") if fecha_asamblea.present?
  end

  def created_at_with_format
    created_at.strftime("%d/%m/%Y %H:%M") if created_at.present?
  end

  def updated_at_with_format
    updated_at.strftime("%d/%m/%Y %H:%M") if updated_at.present?
  end

  def self.to_csv
    headers = ["ID", "Mes", "Año", "Fecha Asamblea", "Creado", "Actualizado"]
    attributes = %w{id mes año fecha_asamblea_with_format created_at_with_format updated_at_with_format}

    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |periodo|
        csv << attributes.map { |attr| periodo.send(attr) }
      end
    end
  end

  def mes_texto
    mes_to_text(mes)
  end

  def mes_texto_asamblea
    mes_to_text(fecha_asamblea.try(:month))
  end

  def dia_texto_asamblea
    dia_to_text(fecha_asamblea)
  end
end
