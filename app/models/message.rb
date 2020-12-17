class Message < ApplicationRecord
  #
  # Database
  #
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :dest, class_name: "User", foreign_key: "dest_id"
  belongs_to :parent_message, class_name: "Message", foreign_key: :mparent_id, optional: true
  belongs_to :root_message, class_name: "Message", foreign_key: :mroot_id, optional: true

  has_many :replies, class_name: "Message", foreign_key: :mparent_id, dependent: :destroy

  scope :visible, ->(user) {
          where(is_public: true).or(where(user_id: user&.id)).or(where(dest_id: user&.id))
        }
  scope :is_root, -> { where(mparent_id: nil) }
  scope :by, ->(user) { where(user_id: user&.id) }

  attr_accessor :all_replies_by_parent
  #
  #
  def load_all_tree_replies_visible(user)
    @all_replies_by_parent = {}
    Message.visible(user).eager_load(:author, :dest).where(mroot_id: self.id).find_each do |m|
      @all_replies_by_parent[m.mparent_id] ||= []
      @all_replies_by_parent[m.mparent_id].push(m)
    end
    @all_replies_by_parent
  end

  #
  # Helpful (?)
  #

  def Message.debug_get_tree_ids()
    Message.all
      .order("mroot_id NULLS FIRST ,mparent_id NULLS FIRST ,id")
      .map { |m| [m.mroot_id, m.mparent_id, m.id] }
  end

  def is_visible?(user)
    return true if is_public?
    if !user.nil?
      return true if user.is_admin? || user.id == self.user_id || user.id == self.dest_id
    end
    return false
  end

  #
  # Validations
  #
  EMAIL_PATTERN = /[\w!#$%&'*+\/=?`{|}~^-]+(?:\.[\w!#$%&'*+\/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}/
  TEL_PATTERN = /(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}/
  DEFAULT_CONTENT_REPLACE = "**confidentiel**"

  validates :content, presence: true
  validate :not_self_message, :coherent_parent_author

  before_validation :replace_confidential
  before_save :check_parent_info

  # @override
  def parent_message=(p)
    super(p)
    check_parent_info
  end

  private

  def replace_confidential()
    replace_in_content(EMAIL_PATTERN)
    replace_in_content(TEL_PATTERN)
  end

  def replace_in_content(pattern, str_replace = DEFAULT_CONTENT_REPLACE)
    unless self.content.nil?
      self.content = self.content.gsub(pattern, str_replace)
    end
  end

  def not_self_message
    if (!user_id.nil? && !dest_id.nil? && dest_id == user_id)
      errors.add(:dest_id, "no self message !")
    end
  end

  def coherent_parent_author
    if (mparent_id.present? && parent_message.user_id != dest_id)
      errors.add(:dest_id, "incoherent reply !")
    end
  end

  #
  # Si le message a un parent on le met d'equerre
  #
  def check_parent_info
    if self.mparent_id
      p = parent_message
      # force correct root id
      self.mroot_id = p.mroot_id || p.id
      #byebug
      # force correct dest (?)
      self.dest_id = p.user_id
      # force coherent visibility !
      self.is_public = p.is_public?
    end
  end
end
