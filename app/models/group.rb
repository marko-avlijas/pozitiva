class Group < ActiveRecord::Base
  has_many :users, inverse_of: :group, dependent: :restrict_with_error 
  has_many :group_offerings, dependent: :restrict_with_error 
  has_many :offers, through: :group_offerings, dependent: :restrict_with_error 
end
