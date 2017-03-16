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

class ProjectsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_project, only: [:show, :edit, :update, :destroy]
    
    #set the pledges on the "show" view, so we know which pledges to display
    before_action :set_pledges, only: [:show]
    
    #authorize user - uses the can can ability to apply to each of the definitions below
    #https://github.com/CanCanCommunity/cancancan/wiki/Authorizing-controller-actions
    load_and_authorize_resource
    
    def index
        @projects = Project.all
        @displayed_projects = Project.take(4)
    end
    
    def new
        @project = Project.new
        @days_to_go = @project.days_to_go
    end
    
    def create
    	@project = current_user.projects.build(project_params)
    
    	respond_to do |format|
    		if @project.save
    			format.html { redirect_to @project, notice: "Project was succesfully created!"}
    			format.json { render :show, status: :ok, location: @project }
    		else
    			format.html { render :new }
    			format.json { render json: @project.errors, status: :unprocessable_entity }
    		end
    	end
    end

    def edit
    end

    def update
        respond_to do |format|
          if @project.update(project_params)
            format.html { redirect_to @project, notice: "Project was successfully updated" }
            format.json { render :show, status: :ok, location: @project }
          else
            format.html { render :edit }
            format.json { render json: @project.errors, status: :unprocessable_entity }
          end
        end
    end
    
    def show
    	@rewards = @project.rewards
    	@days_to_go = @project.days_to_go
    end
    
    def destroy
        @project.destroy
        respond_to do |format|
          format.html { redirect_to project_path, notice: "Project was successfully destroyed" }
          format.json { head :no_content }      
        end
    end
    
  private

    def set_project
      @project = Project.friendly.find(params[:id])
    end

    def project_params
    	params.require(:project).permit(:name, :short_description, :description, :goal, :image_url, :expiration_date)
    end    
    
    def set_pledges
      @pledges = @project.pledges
    end

end
