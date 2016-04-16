# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#owner_id' do
    it 'returns nil if no owner' do
      expect(Comment.new.owner_id).to eq(nil)
    end

    it 'returns owner id' do
      user = FactoryGirl.create(:user)
      comment = FactoryGirl.build(:comment, owner: user)
      expect(comment.owner_id).to eq(user.id)
    end
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
