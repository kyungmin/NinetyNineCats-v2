class Cat < ActiveRecord::Base
  COLORS = ["Black", "Brown", "Orange", "White"]
  attr_accessible :name, :age, :birth_date, :color, :sex
  validates :name, :age, :birth_date, :color, :sex, presence: true
  validates :age, numericality: true
  validates :sex, inclusion: { in: %w(M F) }
  validates :color, inclusion: COLORS

  has_many(
    :cat_rental_requests,
    :class_name => 'CatRentalRequest',
    :primary_key => :id,
    :foreign_key => :cat_id,
    :dependent => :destroy
  )

  belongs_to(
    :owner,
    :class_name => 'User',
    :primary_key => :id,
    :foreign_key => :user_id
  )
end
