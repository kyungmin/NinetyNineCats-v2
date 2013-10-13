class CatRentalRequest < ActiveRecord::Base
  STATUSES = ["APPROVED", "DENIED", "PENDING"]
  
  attr_accessible :cat_id, :end_date, :start_date, :status
  validates :cat_id, :end_date, :start_date, presence: true
  validates :status, inclusion: STATUSES
  before_validation :assign_pending_status
  #validate

  belongs_to(
    :cat,
    :class_name => 'Cat',
    :primary_key => :id,
    :foreign_key => :cat_id
  )

  def approve!
    raise "not pending" unless self.status == 'PENDING'
    transaction do
      self.status = 'APPROVED'
      self.save!

      overlapping_pending_requests.each do |request|
        request.status = 'DENIED'
        request.save!
      end
    end
  end

  def deny!
    self.status = 'DENIED'
    self.save!
  end

  def pending?
    self.status == 'PENDING'
  end

  private
  
  def overlapping_requests
    conditions = <<-SQL
      ((cat_id = :cat_id) AND (start_date < :end_date) AND (end_date > :start_date))
    SQL
    overlapping_requests = CatRentalRequest.where(conditions, {
      cat_id: self.cat_id, start_date: self.start_date, end_date: self.end_date
    })

    if self.id.nil?
      overlapping_requests
    else
      overlapping_requests.where("id != ?", self.id)
    end
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def assign_pending_status
    self.status ||= 'PENDING'
  end
end
