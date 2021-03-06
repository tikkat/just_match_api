# frozen_string_literal: true
require 'administrate/base_dashboard'

class CompanyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    id: Field::Number,
    frilans_finans_id: Field::Number,
    user_frilans_finans_id: Field::Number,
    name: Field::String,
    cin: Field::String,
    website: Field::String,
    email: Field::String,
    street: Field::String,
    zip: Field::String,
    city: Field::String,
    country_name: Field::String,
    phone: Field::String,
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
    :frilans_finans_id,
    :name,
    :cin,
    :users
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :users,
    :id,
    :website,
    :frilans_finans_id,
    :name,
    :cin,
    :email,
    :street,
    :zip,
    :city,
    :country_name,
    :users,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :users,
    :name,
    :cin,
    :email,
    :phone,
    :street,
    :zip,
    :city,
    :user_frilans_finans_id,
    :website,
    :frilans_finans_id
  ].freeze

  # Overwrite this method to customize how skills are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(company)
    "##{company.id} #{company.name}"
  end
end
