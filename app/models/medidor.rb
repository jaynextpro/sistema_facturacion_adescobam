require 'csv'

class Medidor < ApplicationRecord
  belongs_to :cliente, optional: true

  has_many :facturas, dependent: :restrict_with_error

  validates :cliente, presence: true
  validates :medidor, presence: true, uniqueness: true
  validates :sector, presence: true
  validates :activo, inclusion: { in: [true, false], message: "debe ser verdadero o falso" }

  scope :by_keyword, ->(keyword) {
    return all if keyword.blank?

    keyword = keyword&.strip
    joins(:cliente).where('clientes.nombre_completo ILIKE :keyword OR medidor ILIKE :keyword OR direccion ILIKE :keyword', keyword: "%#{keyword}%")
  }

  scope :by_sector, ->(sector) { where(sector: sector) if sector.present? }
  scope :by_activo, ->(activo) { where(activo: activo) if activo.present? }


  def titulo 
    "#{medidor} - #{activo_string}"
  end

  def activo_string
    activo ? 'ACTIVO' : 'INACTIVO'
  end

  # Add methods for formatted date and datetime attributes
  def created_at_with_format
    created_at.strftime("%d/%m/%Y %H:%M") if created_at.present?
  end

  def updated_at_with_format
    updated_at.strftime("%d/%m/%Y %H:%M") if updated_at.present?
  end

  def self.to_csv
    headers = ["ID", "Cliente ID", "Medidor", "Sector", "Estado", "Direccion", "Creado", "Actualizado"]
    attributes = %w{id cliente_id medidor sector activo_string direccion created_at_with_format updated_at_with_format}

    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |medidor|
        csv << attributes.map { |attr| medidor.send(attr) }
      end
    end
  end

  def self.sector_options
    [
      "Col. La Joya",
      "Col. Valle Nuevo",
      "Cas/Los Sánchez",
      "Cas/ Bello Amanecer",
      "Cas/El Foco"
    ]
  end
end
