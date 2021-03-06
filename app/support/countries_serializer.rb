# frozen_string_literal: true
class CountriesSerializer
  def self.serializeble_resource
    countries_data = ISO3166::Country.translations.map do |country_code, _name|
      country = ISO3166::Country[country_code]
      attributes = {
        country_code: country_code,
        local_name: country.local_name
      }
      I18n.available_locales.each do |locale|
        # There is no translations for fa_AF, so fallback on fa
        load_locale = (locale == :fa_AF ? :fa : locale).to_s

        attributes[:"#{locale}_name"] = country.translations[load_locale]
      end
      JsonApiData.new(id: country_code, type: :countries, attributes: attributes)
    end

    JsonApiDatum.new(countries_data)
  end
end
