# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  fullname        :string
#  is_admin        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  before_validation :check_name
  before_validation :check_email

  has_secure_password
  validates :password, presence: true, length: { minimum: 4 }

  def User.find_and_authenticate(email, password)
    user = User.find_by(email: email.downcase)
    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end

  def User.digest(p)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(p, cost: cost)
  end

  def User.allIdNameUserExcept(user)
    User.select([:id, :name]).where.not(id: user.id)
  end

  private

  def trimAndLower!(str)
    if !str.nil?
      str.strip!
      str.downcase!
    end
  end

  def check_name
    trimAndLower!(name)
  end

  def check_email
    trimAndLower!(email)
  end
end
