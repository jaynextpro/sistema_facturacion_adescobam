module ReusableFunctions 
  def mes_to_text(mes_string)
    case mes_string
    when 1
      "Enero"
    when 2
      "Febrero"
    when 3
      "Marzo"
    when 4
      "Abril"
    when 5
      "Mayo"
    when 6
      "Junio"
    when 7
      "Julio"
    when 8
      "Agosto"
    when 9
      "Septiembre"
    when 10
      "Octubre"
    when 11
      "Noviembre"
    when 12
      "Diciembre"
    else
      "Mes Inválido"
    end
  end

  def dia_to_text(fecha)
    I18n.translate("date.day_names")[fecha.wday]
  end
end