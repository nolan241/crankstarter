class RewardsController < ApplicationController
    #make sure user is logged in before displaying rewards
    before_action :authenticate_user!
    
    #rewards belong to projects. need to find the project and set it for the reward
    before_action :set_project

    #need to know to which particular reward we're referring to except 
    before_action :set_reward, except: [:new, :create]

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
   
    def edit
    end
    
    def update
        respond_to do |format|
            if @reward.update(reward_params)
                format.html { redirect_to @project, notice: "Reward was successfully updated"}
            else
                format.html { render :edit }
            end
        end
    end
    
    def destroy
        @reward.destroy
        respond_to do |format|
            format.html { redirect_to projects_path(@project), notice: "Reward successfully destroyed"  }
        end
    end
    
 private 

    def set_project
        @project = Project.friendly.find(params[:project_id])
    end

	def set_reward
		@reward = @project.rewards.find(params[:id])
	end    
    
    def reward_params
        params.require(:reward).permit(:name, :description, :value, :shipping, :number_available, :estimated_delivery)
    end
        
end