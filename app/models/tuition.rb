class Tuition < ActiveRecord::Base
  belongs_to :student_class
  has_many :payments
end
