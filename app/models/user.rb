class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  enum role: [:normal, :admin]
  has_many :students
  has_many :student_classes, :through => :students
  has_many :tuitions, :through => :student_classes
  has_many :supplies, :through => :student_classes
  has_many :attendances, :through => :students
  has_many :payments

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.extra.raw_info.name
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.guardians
    where("role = 0")
  end

end
