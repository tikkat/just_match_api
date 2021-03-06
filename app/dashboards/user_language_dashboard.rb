# frozen_string_literal: true
require 'administrate/base_dashboard'

class UserLanguageDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    language: Field::BelongsTo,
    user: Field::BelongsTo,
    id: Field::Number,
    proficiency: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :user,
    :language,
    :proficiency
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :language,
    :proficiency,
    :user,
    :id,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :language,
    :proficiency,
    :user
  ].freeze

  # Overwrite this method to customize how user languages are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user_language)
  #   "UserLanguage ##{user_language.id}"
  # end
end
