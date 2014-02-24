class GroupOffering < ActiveRecord::Base
  belongs_to :group
  belongs_to :offer
end
