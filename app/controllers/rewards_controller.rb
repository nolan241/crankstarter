class RewardsController < ApplicationController
    #make sure user is logged in before displaying rewards
    before_action :authenticate_user!
    
    #rewards belong to projects. need to find the project and set it for the reward
    before_action :set_project
    
    def new
        @reward = @project.rewards.build
        respond_to do |format|
            format.html
        end
    end
    
    def create
        @reward = @project.rewards.build(reward_params)
    
        respond_to do |format|
            if @reward.save
                format.html { redirect_to @project, notice: "Reward was successfully created" }
            else
                format.html { render :new }
            end
        end
    end
    
 private 
        
    def set_project
        @project = Project.find(params[:project_id])
    end
    
    def reward_params
        params.require(:reward).permit(:name, :description, :value, :shipping, :number_available, :estimated_delivery)
    end
        
end