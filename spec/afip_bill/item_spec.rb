require 'spec_helper'
require 'afip_bill/line_item'

describe AfipBill::LineItem do
  subject { described_class }

  let(:item) { AfipBill::LineItem.new('Item', 1, 100) }
  let(:item_zero_quantity) { AfipBill::LineItem.new('Item', 0, 100) }
  let(:item_multiple_units) { AfipBill::LineItem.new('Item', 10, 100) }

  let(:item_custom_iva) { AfipBill::LineItem.new('Item', 1, 100, 5) }
  let(:item_custom_iva_zero_quantity) { AfipBill::LineItem.new('Item', 0, 100, 5) }
  let(:item_custom_iva_multiple_units) { AfipBill::LineItem.new('Item', 10, 100, 5) }

  describe '#new' do
    it 'must be created with name, quantity and imp_unitario' do
      item = AfipBill::LineItem.new('Item', 1, 100)

      expect(item).to be_an_instance_of AfipBill::LineItem
    end

    it 'can be created with name, quantity, imp_unitario, iva_percentage' do
      item = AfipBill::LineItem.new('Item', 1, 100, 5)

      expect(item).to be_an_instance_of AfipBill::LineItem
    end
  end

  describe 'attributes' do
    it 'has name' do
      expect(item.name).to eq 'Item'
    end

    it 'has quantity' do
      expect(item.quantity).to eq 1
    end

    it 'has imp_unitario' do
      expect(item.imp_unitario).to eq 100
    end

    describe 'iva_percentage' do
      it 'has iva_percentage' do
        expect(item_custom_iva.iva_percentage).to eq 5
      end

      it 'defaults to 21' do
        expect(item.iva_percentage).to eq 21
      end
    end
  end

  describe '#imp_total_unitario' do
    it 'should calculate imp_total_unitario for quantity zero' do
      expect(item_zero_quantity.imp_total_unitario).to be_zero
    end

    it 'should calculate imp_total_unitario for quantity one' do
      expect(item.imp_total_unitario).to eq 100
    end

    it 'should calculate imp_total_unitario for quantity greater than one' do
      expect(item_multiple_units.imp_total_unitario).to eq 1000
    end
  end

  describe '#imp_iva' do
    describe 'default IVA (21%)' do
      it 'should calculate imp_iva for quantity zero' do
        expect(item_zero_quantity.imp_iva).to be_zero
      end

      it 'should calculate imp_iva for quantity one' do
        expect(item.imp_iva).to eq 21
      end

      it 'should calculate imp_iva for quantity greater than one' do
        expect(item_multiple_units.imp_iva).to eq 210
      end
    end

    describe 'custom IVA' do
      it 'should calculate imp_iva for quantity zero' do
        expect(item_custom_iva_zero_quantity.imp_iva).to be_zero
      end

      it 'should calculate imp_iva for quantity one' do
        expect(item_custom_iva.imp_iva).to eq 5
      end

      it 'should calculate imp_iva for quantity greater than one' do
        expect(item_custom_iva_multiple_units.imp_iva).to eq 50
      end
    end
  end

  describe '#imp_total_unitario_con_iva' do
    describe 'default IVA (21%)' do
      it 'should calculate imp_total_unitario_con_iva for quantity zero' do
        expect(item_zero_quantity.imp_total_unitario_con_iva).to be_zero
      end

      it 'should calculate imp_total_unitario_con_iva for quantity one' do
        expect(item.imp_total_unitario_con_iva).to eq 121
      end

      it 'should calculate imp_total_unitario_con_iva for quantity greater than one' do
        expect(item_multiple_units.imp_total_unitario_con_iva).to eq 1210
      end
    end

    describe 'custom IVA' do
      it 'should calculate imp_total_unitario_con_iva for quantity zero' do
        expect(item_custom_iva_zero_quantity.imp_total_unitario_con_iva).to be_zero
      end

      it 'should calculate imp_total_unitario_con_iva for quantity one' do
        expect(item_custom_iva.imp_total_unitario_con_iva).to eq 105
      end

      it 'should calculate imp_total_unitario_con_iva for quantity greater than one' do
        expect(item_custom_iva_multiple_units.imp_total_unitario_con_iva).to eq 1050
      end
    end
  end
end
