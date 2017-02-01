class PaymentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project
    before_action :set_reward
    before_action :set_amount
    before_action :set_client_token

    def new
        @pledge = current_user.pledges.build(payment_params
        )
        @rewards = @project.rewards
        
        respond_to do |format|
        end
    end

private
    def set_project
        @project = Project.find(params[:project_id])
    end
    
    def set_amount
        @amount = payment_params[:amount].to.i
    end
    
    def set_reward
        @reward = @project.rewards.find_by_id(payment_params[:reward_id])
    end
    
    def set_token
        @client_token = Braintree::ClientToken.generate(:customer_id => current_user.customer_id)
    end
    
    def payment_params
         params.require(:pledge).permit(:reward_id, :name, :amount, :address, :city, :country, :postal_code)
    end

end