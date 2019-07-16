class Cart
  attr_accessor :price, :shipping_price, :store_credits

  def initialize
    @price = 0
    @shipping_price = 0
    @store_credits = 0
  end

  def add(item, quantity, summer_sale)
    return unless Inventory.has?(item, quantity)

    line_item = LineItem.build(item, quantity, summer_sale)

    update_price(line_item)
    update_store_credits(line_item)
    update_shipping_price(line_item)
  end

  private

  def update_price(line_item)
    self.price += line_item.price
  end

  def update_store_credits(line_item)
    self.store_credits += line_item.store_credits
  end

  def update_shipping_price(line_item)
    self.shipping_price += line_item.shipping_price
  end

  class LineItem
    def self.build(item, quantity, summer_sale)
      klass = if summer_sale
                SummerSaleLineItem
              else
                self
              end

      klass.new(item, quantity)
    end

    attr_reader :item, :quantity

    def initialize(item, quantity)
      @item = item
      @quantity = quantity
    end

    def price
      item.price * quantity
    end

    def store_price
      item.price * quantity * 0.2
    end

    def shipping_price
      item.shipping_price * quantity
    end
  end

  class SummerSaleLineItem
    attr_reader :item, :quantity

    def initialize(item, quantity)
      @item = item
      @quantity = quantity
    end

    def price
      item.price * quantity * 0.9
    end

    def store_price
      item.price * quantity * 0.1
    end

    def shipping_price
      Money.zero
    end
  end
end
