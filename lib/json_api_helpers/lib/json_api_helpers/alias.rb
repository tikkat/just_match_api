# frozen_string_literal: true
module JsonApiHelpers
  module Alias
    JsonApiErrors = Serializers::Errors
    JsonApiData = Serializers::Data
    JsonApiDatum = Serializers::Datum

    JsonApiErrorSerializer = Serializers::ModelError
    JsonApiSerializer = Serializers::Model

    JsonApiDeserializer = Serializers::Deserializer

    JsonApiFilterParams = Params::Filter
    JsonApiSortParams = Params::Sort
    JsonApiFieldsParams = Params::Fields
    JsonApiIncludeParams = Params::Includes
  end
end
