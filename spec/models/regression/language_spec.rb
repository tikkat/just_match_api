# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Language, regressor: true do
  # === Relations ===

  it { is_expected.to have_many :user_languages }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :jobs }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :lang_code }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :en_name }
  it { is_expected.to have_db_column :direction }
  it { is_expected.to have_db_column :local_name }
  it { is_expected.to have_db_column :system_language }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['lang_code'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :lang_code }

  # === Validations (Numericality) ===

  # === Enums ===
end
