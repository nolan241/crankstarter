# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  short_description :text
#  description       :text
#  image_url         :string
#  status            :string           default("pending")
#  goal              :decimal(8, 2)
#  expiration_date   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Project < ActiveRecord::Base
    
    #generate friendly url for the projects paths
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
    
    belongs_to :user
    has_many :rewards

    validates :expiration_date, date: { after: Date.today }
    validates :name, :short_description, :description, :image_url, :goal, :expiration_date, presence: true
    after_create :charge_backers_if_funded
    

	def pledges
		rewards.flat_map(&:pledges)
	end
	
    def total_backed_amount
        pledges.map(&:amount).inject(0, :+)
    end

    def funded?
        status == "funded"
    end
    
    def expired?
        status = "expired"
    end
    
    def canceled?
        status == "canceled"
    end
    
    def funded!
        update(status: "funded")
    end
    
    def expired!
        update(status: "expired")
        void_pledges
    end
    
    def canceled!
        update(status: "canceled")
        void_pledges
    end


  private

    def void_pledges
      self.pledges.each { |p| p.void! }
    end

    def start_project
      self.expiration_date = 1.month.from_now
    end
    
    #execute the code in the charge_backers_job.rb file once the expiration date is reached
    def charge_backers_if_funded
      ChargeBackersJob.set(wait_until: self.expiration_date).perform_later self.id
    end
    
    def slug_candidates
        [
            :name, 
            [:name, :created_at]
        ]
    end

end