class Settlement < ApplicationRecord

	belongs_to :payee,
    :class_name => "User",
    :foreign_key => :payee_id

    belongs_to :receiver,
    :class_name => "User",
    :foreign_key => :receiver_id
end
