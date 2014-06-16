module CourseCalendar
  extend ActiveSupport::Concern

  included do
    helper_method :today
    helper_method :day
    before_filter :allowed_day?
  end

  private

  def day
    d = params[:number] || params[:day_number]
    @day ||= case d
    when nil, 'today'
      today
    when 'yesterday'
      yesterday
    else
      d
    end
    @day = last_day if completed_course?
    @day
  end

  def completed_course?
    week >= WEEKS
  end

  # The last day of the program is the final weekend (w8e for us)
  def last_day
    "w#{WEEKS}e"
  end

  def week
    @day.match(/^w(\d+)/)[1].to_i
  end

  def today
    @today ||= CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
  end

  def yesterday
    @yesterday ||= CurriculumDay.new((Time.zone.now.to_date - 1).to_date, cohort).to_s
  end

  def allowed_day?
    # raise day.inspect
    redirect_to(day_path('today'), alert: 'Access not allowed yet!') unless current_user.can_access_day?(day)
  end

end
