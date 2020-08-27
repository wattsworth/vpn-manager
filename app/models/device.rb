class Device < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :groups

  auto_strip_attributes :public_key, :host_ip_address, :vpn_ip_address, :hostname, :location
  validates :public_key, uniqueness: true, presence: true
  validates :vpn_ip_address, uniqueness: true, presence: true
  validates :hostname, uniqueness: true, presence: true

  def short_name
    hostname.split('.')[0]
  end
end
