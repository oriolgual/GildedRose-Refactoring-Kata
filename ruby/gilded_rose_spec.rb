require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("+5 Dexterity Vest", 0, 0)]
      GildedRose.new(items).update_quality
      items[0].name.should == "+5 Dexterity Vest"
    end

    it 'decreases the sell in by one' do
      items = [Item.new("+5 Dexterity Vest", 0, 0)]
      GildedRose.new(items).update_quality
      items[0].sell_in.should eq(-1)
    end

    context "when it's a regular item" do
      context "and the sell in date hasn't passed" do
        it 'decreases the quality' do
          items = [Item.new("+5 Dexterity Vest", 1, 10)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 9
        end
      end

      context "and the sell in date has passed" do
        it 'decreases the quality twice faster' do
          items = [Item.new("+5 Dexterity Vest", 0, 10)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 8
        end
      end

      context 'and the item has no value' do
        it "doesn't decrease the quality" do
          items = [Item.new("+5 Dexterity Vest", 0, 0)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 0
        end
      end
    end

    context "when the item is Sulfuras" do
      it "doesn't change its quality" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
        GildedRose.new(items).update_quality
        items[0].quality.should == 80
      end

      it "doesn't change its sell in" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 10, 80)]
        GildedRose.new(items).update_quality
        items[0].sell_in.should == 10
      end
    end

    context "when the item is Aged Brie" do
      context "and the sell in date hasn't passed" do
        it "increases its quality by 1" do
          items = [Item.new("Aged Brie", 1, 10)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 11
        end
      end

      context "and the sell in date has passed" do
        it "increases its quality by 2" do
          items = [Item.new("Aged Brie", 0, 10)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 12
        end
      end

      it "doesn't increase its value over 50" do
        items = [Item.new("Aged Brie", 0, 50)]
        GildedRose.new(items).update_quality
        items[0].quality.should == 50
      end
    end

    context "when the item is a backstage ticket" do
      context "and the sell in date hasn't passed" do
        it "doesn't increase its value over 50" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 50)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 50
        end

        context "and there are more then 10 days for the concert" do
          it 'increases its value by 1' do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 5)]
            GildedRose.new(items).update_quality
            items[0].quality.should == 6
          end
        end

        context "and there are 10 days or less for the concert" do
          it 'increases its value by 2' do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 5)]
            GildedRose.new(items).update_quality
            items[0].quality.should == 7
          end
        end

        context "and there are 5 days or less for the concert" do
          it 'increases its value by 3' do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)]
            GildedRose.new(items).update_quality
            items[0].quality.should == 8
          end
        end
      end

      context "when the concert has ended" do
        it "drops its quality to 0" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 50)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 0
        end
      end
    end

    context 'when the item is a conjured item' do
      it 'decreases the quality by two each day' do
        items = [Item.new("Conjured Mana Cake", 1, 10)]
        GildedRose.new(items).update_quality
        items[0].quality.should == 8
      end

      context "and the sell in date has passed" do
        it 'decreases the quality by four each day' do
          items = [Item.new("Conjured Mana Cake", 0, 10)]
          GildedRose.new(items).update_quality
          items[0].quality.should == 6
        end
      end
    end
  end
end
