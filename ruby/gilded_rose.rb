class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if immutable_item?(item)
      make_day_pass(item)
      update_item_at_end_of_day(item)
      update_item_after_sell_date(item)
    end
  end

  private
  def update_item_at_end_of_day(item)
    if regular_item?(item)
      decrease_quality(item)
    else
      increase_quality(item)
    end
  end

  def update_item_after_sell_date(item)
    return unless sell_date_passed?(item)

    if aged_brie?(item)
      increase_quality(item)
    else
      decrease_quality(item)
    end
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

  def sell_date_passed?(item)
    item.sell_in < 0
  end

  def make_day_pass(item)
    item.sell_in -= 1
  end

  def decrease_quality(item)
    return if item.quality == 0

    item.quality -= 1
    item.quality -= 1 if conjured_item?(item)
    item.quality = 0  if backstage_ticket?(item)
  end

  def increase_quality(item)
    return if item.quality == 50
    item.quality += 1

    if backstage_ticket?(item)
      item.quality += 1 if item.sell_in < 10
      item.quality += 1 if item.sell_in < 5
    end
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