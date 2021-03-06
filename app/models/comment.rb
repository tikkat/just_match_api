# frozen_string_literal: true
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'
  belongs_to :language

  validates :owner_user_id, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true
  validates :body, presence: true
  validates :language, presence: true

  scope :visible, -> { where(hidden: false) }

  # Needed for administrate
  # see https://github.com/thoughtbot/administrate/issues/354
  def owner_id
    owner.try!(:id)
  end
end
# rubocop:disable Metrics/LineLength

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  commentable_id   :integer
#  commentable_type :string
#  owner_user_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  language_id      :integer
#  hidden           :boolean          default(FALSE)
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_language_id                          (language_id)
#
# Foreign Keys
#
#  comments_owner_user_id_fk  (owner_user_id => users.id)
#  fk_rails_f55d9b0548        (language_id => languages.id)
#
