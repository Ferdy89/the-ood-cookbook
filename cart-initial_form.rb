class Cart
  attr_accessor :price, :shipping_price, :store_credits

  def initialize
    @price = 0
    @shipping_price = 0
    @store_credits = 0
  end

  def add(item, quantity, summer_sale)
    return unless Inventory.has?(item, quantity)

    self.price += if summer_sale
                    item.price * quantity * 0.9
                  else
                    item.price * quantity
                  end

    self.store_credits += if summer_sale
                            item.price * quantity * 0.1
                          else
                            item.price * quantity * 0.2
                          end

    return if summer_sale

    self.shipping_price += item.shipping_price * quantity
  end
end
