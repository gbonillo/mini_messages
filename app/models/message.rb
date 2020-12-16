class Message < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :dest, class_name: "User", foreign_key: "dest_id"
  belongs_to :parent_message, class_name: "Message", foreign_key: :mparent_id, optional: true
  belongs_to :root_message, class_name: "Message", foreign_key: :mroot_id, optional: true

  has_many :replies, class_name: "Message", foreign_key: :mparent_id
  has_many :tree_messages, class_name: "Message", foreign_key: :mroot_id

  has_many :visible_replies,
    ->(user) {
      where(is_public: true).or(user_id: user&.id).or(dest_id: user&.id)
    },
    class_name: "Message", foreign_key: :mparent_id

  scope :is_root, -> { where(mparent_id: nil) }

  scope :by, ->(user) { where(user_id: user&.id) }

  scope :visible, ->(user) {
          where(is_public: true).or(where(user_id: user&.id)).or(where(dest_id: user&.id))
        }

  validates :content, presence: true
  validate :not_self_message, :coherent_parent_author

  def is_visible?(user)
    return true if is_public?
    if !user.nil?
      return true if user.is_admin? || user.id == self.user_id || user.id == self.dest_id
    end
    return false
  end

  private

  def not_self_message
    if (dest_id == user_id)
      errors.add(:dest_id, "no self message !")
    end
  end

  def coherent_parent_author
    if (mparent_id.present? && parent_message.user_id != dest_id)
      errors.add(:dest_id, "incoherent reply !")
    end
  end
end
