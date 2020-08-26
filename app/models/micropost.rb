class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.validations.content.max_length }
  validates :image, content_type: { in: Settings.files.image_type, message: I18n.t("micropost.error.imageformat") }, size: { less_than: Settings.files.pic_size.megabytes, message: I18n.t("micropost.error.sizeformat") }

  scope :recent_posts, ->{order created_at: :desc}

  def display_image
    image.variant(resize_to_limit: [Settings.files.pic_resize, Settings.files.pic_resize])
  end
end
