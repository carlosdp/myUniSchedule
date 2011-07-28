class User < ActiveRecord::Base
  has_one :schedule
end
