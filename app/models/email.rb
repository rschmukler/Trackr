class Email < ActiveRecord::Base
  validates :from_text, :presence => true
  validates :body_text, :presence => true
  validates :subject_text, :presence => true
end
