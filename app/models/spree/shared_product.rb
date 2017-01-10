class Spree::SharedProduct < ActiveRecord::Base
  belongs_to :variant
  belongs_to :sharedlist

  def amount
    ## FIXME_NISH Rename it to amount.
    quantity * variant.price
  end

  def display_total
    Spree::Money.new(amount)
  end
end
