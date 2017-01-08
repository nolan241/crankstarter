class ProjectsController < ApplicationController
    def index
        @projects = Project.all
        @displayed_projects = Project.take(4)
    end
end
