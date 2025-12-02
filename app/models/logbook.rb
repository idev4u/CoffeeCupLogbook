class Logbook < ApplicationRecord

    validates :cup_type, presence: true, length: { maximum: 100 }
    validates :amount, presence: true, numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 10
            }
end
