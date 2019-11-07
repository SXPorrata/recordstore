class User < ApplicationRecord
    has_secure_Password
    has_many    :records
end
