# frozen_string_literal: true
module FrilansFinans
  module InvoiceWrapper
    def self.attributes(job:, user:, tax:, ff_user:)
      {
        invoice: {
          invoiceuser: invoice_users(job: job, user: user, ff_user: ff_user),
          invoicedate: invoice_dates(job: job)
        }.merge!(invoice_data(job: job, user: user, tax: tax))
      }
    end

    def self.invoice_data(job:, user:, tax:)
      {
        currency_id: Currency.default_currency.try!(:frilans_finans_id),
        specification: "#{job.category.name} - #{job.name} (##{job.id})",
        amount: job.amount,
        company_id: job.company.frilans_finans_id,
        tax_id: tax.id,
        user_id: user.frilans_finans_id,
        pre_report: true
      }
    end

    def self.invoice_users(job:, user:, ff_user:)
      ff_user_attributes = ff_user.resource.attributes

      taxkey_id = ff_user_attributes['default_taxkey_id'] if ff_user.resource.attributes

      [{
        user_id: user.frilans_finans_id,
        total: job.amount,
        taxkey_id: taxkey_id,
        allowance: 0,
        travel: 0,
        save_vacation_pay: 0,
        save_itp: 0,
        express_payment: 0
      }]
    end

    def self.invoice_dates(job:)
      workdays = job.workdays
      hours_per_date = job.hours / workdays.length
      # Frilans Finans wants hours rounded to the closets half
      hours_per_date_rounded = (hours_per_date * 2).round.to_f / 2
      workdays.map do |date|
        {
          date: date,
          hours: hours_per_date_rounded
        }
      end
    end
  end
end
