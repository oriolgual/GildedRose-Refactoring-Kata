class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if immutable_item?(item)

      if regular_item?(item)
        decrease_quality(item)
        decrease_quality(item) if conjured_item?(item)
      elsif can_increase_quality?(item)
        increase_quality(item)

        if backstage_ticket?(item)
          increase_quality(item) if item.sell_in < 11
          increase_quality(item) if item.sell_in < 6
        end
      end

      make_day_pass(item)

      if sell_date_passed?(item)
        if backstage_ticket?(item)
          reset_quality(item)
        elsif aged_brie?(item)
          increase_quality(item)
        elsif regular_item?(item)
          decrease_quality(item)
          decrease_quality(item) if conjured_item?(item)
        end
      end
    end
  end

  private
  def make_day_pass(item)
    item.sell_in -= 1
  end

  def immutable_item?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def backstage_ticket?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def aged_brie?(item)
    item.name == "Aged Brie"
  end

  def conjured_item?(item)
    item.name =~ /Conjured/
  end

  def regular_item?(item)
    !(aged_brie?(item) || backstage_ticket?(item))
  end

  def decrease_quality(item)
    return if item.quality == 0
    item.quality -= 1
  end

  def increase_quality(item)
    return if item.quality == 50
    item.quality += 1
  end

  def reset_quality(item)
    item.quality = 0
  end

  def sell_date_passed?(item)
    item.sell_in < 0
  end

  def can_increase_quality?(item)
    !regular_item?(item) && item.quality < 50
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end