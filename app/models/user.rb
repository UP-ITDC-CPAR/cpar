class User < ActiveRecord::Base
  has_many :issues
  has_many :activities
  has_many :causes
  belongs_to :user_type, :foreign_key => 'type_id'
  belongs_to :department

  has_many :issue_attachments

  attr_accessible :department_id, :email, :mobile, :name, :phone, :type_id, 
  						:password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, on: :create }
  validates :password_confirmation, presence: { on: :create }

  def send_password_reset
    create_password_reset_token
    sent = false
    self.password_reset_sent_at = Time.zone.now
    save!
	begin
	    UserMailer.password_reset(self).deliver
	    sent = true
	rescue
	    # works like java's try-catch blocks and catches the errors
	end
	sent
  end

  def send_verification_email
    create_verification_token
    sent = false
    self.verification_sent_at = Time.zone.now
    save!
	begin
	    UserMailer.verify_email(self).deliver
	    sent = true
	rescue
	   # works like java's try-catch blocks and catches the errors
	end
	sent
  end

  def send_notification_email(title, content)
	begin
	    UserMailer.notify_email(self, title, content).deliver
	rescue
	   # works like java's try-catch blocks and catches the errors
	end
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def create_password_reset_token
      self.password_reset_token = SecureRandom.urlsafe_base64
    end

    def create_verification_token
      self.verification_token = SecureRandom.urlsafe_base64
    end
end
