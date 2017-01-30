class Pledge < ActiveRecord::Base
    belongs_to :user
    belongs_to :reward
    
    before_validation :generate_uuid!, :on => :create
    
    validates_presence_of :name, :address, :city, :country, :postal_code, :amount, :user_id
    
    def generate_uuid!
        begin 
            self.uuid = SecureRandom.hex(16)
        end while Pledge.find_by(:uuid => self.uuid).present?
    end
    
end
