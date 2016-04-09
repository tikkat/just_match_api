# frozen_string_literal: true
module ErrorSerializer
  def self.serialize(model)
    model.errors.messages.map do |field, errors|
      # Transform field_name to field-name as per jsonapi spec
      dashed_field = field.to_s.dasherize
      errors.map do |error_message|
        {
          status: 422,
          source: { pointer: "/data/attributes/#{dashed_field}" },
          detail: error_message
        }
      end
    end.flatten
  end
end
