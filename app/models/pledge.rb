class Pledge < ActiveRecord::Base
    belongs_to :user
    belongs_to :reward
    after_create :check_if_funded
    
    before_validation :generate_uuid!, :on => :create
    validates_presence_of :name, :address, :city, :country, :postal_code, :amount, :user_id
    
    def generate_uuid!
        begin 
            self.uuid = SecureRandom.hex(16)
        end while Pledge.find_by(:uuid => self.uuid).present?
    end
    
    #check if funcded http://edgeguides.rubyonrails.org/active_job_basics.html
    def check_if_funded
        project.funded! if project.total_backed_amount >= project.goal
    end    
    
    #charges the user, creates a new Braintree transaction 
    def charge!
        #don't charge
        return false if self.charged? || !self.project.funded?
            id = user.customer_id
        #if the user's customer_id is present and the client exists, with the customer_id and amount specified.
        if id.present? && @customer = Braintree::Customer.find(id)
          result = Braintree::Transaction.sale(
            :customer_id => @customer_id,
            :amount => self.amount
          )
          #change it to charged
          if result.success?
            self.charged!
          #void if not
          else
            self.void!
          end
        end
    end

    
    #check if status is charged
    def charged?
        status == "charged"
    end
    
    def failed?
        status == "failed"
    end
    
    def pending?
        status == "pending"
    end
    
    #update status to charged
    def charged!
        update(status: "charged")
    end
    
    def void!
        update(status: "void")
    end
    
end