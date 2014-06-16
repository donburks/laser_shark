class CohortsController < ApplicationController

  before_action :require_teacher

  def switch_to
    @cohort = Cohort.find params[:id]
    session[:cohort_id] = @cohort.id
    redirect_to day_path('today'), notice: "Switched to #{@cohort.name} cohort!"
  end

  protected

  def require_teacher
    redirect_to :root, alert: 'Only teachers can do this!' unless teacher?
  end

end
