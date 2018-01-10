class Upload < ApplicationRecord
  # reference to user that created it
  belongs_to :user
  
  # filename is a required field
  validates :filename, presence: true
  
  # content type is a required field
  validates :content_type, presence: true
  
  # category is a required field
  validates :category, presence: true
  
  # upload states
  enum status: {
    draft: 'draft',
    uploading: 'uploading',
    uploaded: 'uploaded',
    aborted: 'aborted'
  }
  
  # non-persistent variable to hold signed PUT URL
  attr_accessor :signed_url
  
  # set defaults if instance is new
  after_initialize :set_defaults, unless: :persisted?
  
  # set status attribute to 'new' by default
  def set_defaults
    self.status = 'draft' if self.status.blank?
  end
  
  # create a path
  def path
    if self.persisted?
      # construct an S3 key for the file that can be signed to grant temporary put access by
      # using the provided 'prefix' attribute, converting the instance's ID into a 9 character
      # string and separating into groups of three, and then appending the current filename as is
      str_id = self.id.to_s.rjust(9, '0').scan(/\d{3}/).join('/')
      return "uploads/#{category}/#{str_id}/#{self.filename}"
    end
  end
end
