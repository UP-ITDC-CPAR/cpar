class IsoNc < ActiveRecord::Base
  has_many :issues
  
  attr_accessible :title
end
