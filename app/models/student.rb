class Student < ApplicationRecord
  validates :first_name, :last_name, :surname, :class_id, :school_id, presence: true
end
