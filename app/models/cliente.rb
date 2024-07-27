require 'csv'

class Cliente < ApplicationRecord
  has_many :medidores, dependent: :restrict_with_error

  before_validation :normalize_dui

  validates :dui, presence: true,
                  format: { with: /\A\d{8}-\d{1}\z/, message: "debe tener 9 dígitos, con guion" },
                  uniqueness: {case_sensitive: false }
  validates :nombre_completo, presence: true

  def titulo
    "#{dui} - #{nombre_completo}"
  end

  # Add methods for formatted date and datetime attributes
  def created_at_with_format
    created_at.strftime("%d/%m/%Y %H:%M") if created_at.present?
  end

  def updated_at_with_format
    updated_at.strftime("%d/%m/%Y %H:%M") if updated_at.present?
  end

  def self.to_csv
    headers = ["ID", "DUI", "Nombre Completo", "Creado", "Actualizado"]
    attributes = %w{id dui nombre_completo created_at_with_format updated_at_with_format}

    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |cliente|
        csv << attributes.map { |attr| cliente.send(attr) }
      end
    end
  end

  private

  def normalize_dui
    return if dui.blank?

    unless dui.match(/\A\d{8}-\d{1}\z/)
      normalized_dui = dui.delete('-')
      self.dui = normalized_dui.insert(8, '-') if normalized_dui.length == 9
    end
  end
end
