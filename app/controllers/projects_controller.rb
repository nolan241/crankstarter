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
    
    def index
        @projects = Project.all
        @displayed_projects = Project.take(4)
    end
    
    
    def show
    end
    
    
    def new
        @project = Project.new
    end
    
    
    def edit
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
    

    def destroy
        @project.destroy
        respond_to do |format|
          format.html { redirect_to project_path, notice: "Project was successfully destroyed" }
          format.json { head :no_content }      
        end
    end
    
    
    private

    def set_project
      @project = Project.find(params[:id])
    end
    
    def project_params
      params.require(:project).permit(:name, :short_description, :description, :goal, :image_url, :expiration_date)
    end

end
