class Item < ApplicationRecord

	self.table_name = "gipi_item"
	self.primary_key = "item_no"

	alias_attribute :item_pol_id, :policy_id
	alias_attribute :item_number, :item_no

	belongs_to :policy, foreign_key: :policy_id
	belongs_to :motorpolicy, foreign_key: :policy_id
	belongs_to :accident_item, foreign_key: :item_no
	has_one :item_peril , foreign_key: :item_no
	belongs_to :vehicle, foreign_key: :policy_id, primary_key: :policy_id

end
