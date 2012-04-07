class User < ActiveRecord::Base
  has_and_belongs_to_many :notes
  attr_accessible :public_key
end
