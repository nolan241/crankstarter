#setting the queue priority as "default" and, inside the "perform" method, we're charging each and every pledge for each and every user, unless the pledge is already "charged"

class ChargeBackersJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    @project = Project.find(id)
    if @project.funded?
      @project.pledges.each do |pledge|
        pledge.charge! unless pledge.charged?
      end
    else
      @project.expired!
    end
  end

end