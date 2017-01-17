class Spree::SharedProduct < ActiveRecord::Base
  belongs_to :variant
  belongs_to :shared_list

  def amount
    ## FIXME_NISH Rename it to amount.
    quantity * variant.price
  end

  def display_total
    Spree::Money.new(amount)
  end

  def add_to_current_order(order)
    errors = ''
    begin
      order.contents.add(variant, quantity)
    rescue ActiveRecord::RecordInvalid => e
      errors = e.record.errors.full_messages.join(", ")
    end
    errors
  end
end
