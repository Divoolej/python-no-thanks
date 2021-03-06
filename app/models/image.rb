class Image < ActiveRecord::Base
  acts_as_taggable_on :tags
  acts_as_commentable
  acts_as_votable

  has_attached_file :picture,
    styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: ":style/missing.png",
    storage: :dropbox,
    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
    dropbox_options: {}

  belongs_to :user
  belongs_to :gallery

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :user, :title, :description, presence: true
end
