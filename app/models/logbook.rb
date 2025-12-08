class Logbook < ApplicationRecord
    before_validation :set_package_size_from_type

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

    def set_package_size_from_type
      case cup_type
      when "Probe Package"
        self.package_size_grams = 250
      when "Plauen Gold Package"
        self.package_size_grams = 500
      else
        self.package_size_grams = nil
      end
    end
end
