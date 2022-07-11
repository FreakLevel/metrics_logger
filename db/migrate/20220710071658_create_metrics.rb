# frozen_string_literal: true

class CreateMetrics < ActiveRecord::Migration[7.0]
  def up
    create_table :metrics do |t|
      t.string :name, null: false
      t.float :value, null: false
      t.datetime :timestamp, null: false, default: -> { 'CURRENT_TIMESTAMP' }, index: true
      t.timestamps
    end
  end

  def down
    drop_table :metrics
  end
end
