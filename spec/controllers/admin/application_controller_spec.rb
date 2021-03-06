# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Admin::ApplicationController, type: :controller do
  it 'has default records per page' do
    allow_any_instance_of(described_class).to receive(:params).and_return({})
    expected = described_class::DEFAULT_RECORDS_PER_PAGE
    expect(described_class.new.records_per_page).to eq(expected)
  end

  it 'can read per page from params' do
    expected = 25
    allow_any_instance_of(described_class).to receive(:params).
      and_return(per_page: expected)
    expect(described_class.new.records_per_page).to eq(expected)
  end

  it 'sets en locale in ' do
    allow(I18n).to receive(:locale=).and_return(:en)
    described_class.new.set_en_locale
    expect(I18n).to have_received(:locale=)
  end
end
