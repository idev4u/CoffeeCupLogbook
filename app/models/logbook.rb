class Logbook < ApplicationRecord

    validates :cup_type, presence: true, length: { maximum: 100 }
    validates :amount, presence: true, numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 10
            }
    validate :package_size_required_for_package

    private

    def package_size_required_for_package
      if cup_type == "Package" && package_size_grams.blank?
        errors.add(:package_size_grams, "must be set for packages")
      end
    end
end
