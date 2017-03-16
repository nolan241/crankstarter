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

module ProjectsHelper
    #adds message in the project stats
    def funding_status_message(project)
        case project.status
          when "pending"
            "This project will only be funded if, at least, #{number_to_currency(project.goal, unit: '$')} is pledged by #{project.expiration_date}."
          when "funded"
            "This project will be funded on #{project.expiration_date}."
          when "expired"
            "This project failed to meet the goal."
          when "canceled"
            "This project has been canceled."
        end              
    end
    
    
end
