class ChangeDataTypeForPostContent < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.change :content, :text
    end
  end
 
  def self.down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_table :posts do |t|
      t.change :content, :string
    end
  end
end
