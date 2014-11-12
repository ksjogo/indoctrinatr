# == Schema Information
#
# Table name: document_submissions
#
#  id          :integer          not null, primary key
#  template_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  content     :text             default(""), not null
#

class DocumentSubmission < ActiveRecord::Base
  # associations
  belongs_to :template
  has_many :submitted_template_fields, dependent: :destroy
  has_many :template_fields, through: :submitted_template_fields

  accepts_nested_attributes_for :submitted_template_fields

  # delegations
  delegate :name, to: :template, prefix: :template
  delegate :template_asset_path, to: :template # adds method 'template_asset_path' to allow TeX templates to include assets

  # scopes
  scope :recent_first, -> { order(created_at: :desc) }

  def submitted_values
    SubmittedValues.new(template_asset_path, submitted_template_fields)
  end
end
