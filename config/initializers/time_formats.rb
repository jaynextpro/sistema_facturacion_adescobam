# config/initializers/date_formats.rb

# Define custom formats for Date, Time, and DateTime
Date::DATE_FORMATS[:default] = "%d/%m/%Y"        # e.g., 31/12/2023
Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"  # e.g., 31/12/2023 23:59
DateTime::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"  # e.g., 31/12/2023 23:59

# Optionally, define other formats as needed
Date::DATE_FORMATS[:short] = "%e %b %Y"         # e.g., 31 Dec 2023
Time::DATE_FORMATS[:short] = "%e %b %Y %H:%M"   # e.g., 31 Dec 2023 23:59
DateTime::DATE_FORMATS[:short] = "%e %b %Y %H:%M"   # e.g., 31 Dec 2023 23:59
