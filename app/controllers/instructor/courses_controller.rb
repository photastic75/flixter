class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:show]

  def create
    @course = current_user.courses.create(course_params)
    if @course.valid?     
      redirect_to instructor_course_path(@course)  
    else
      render :new, status: :unprocessable_entity
    end 
  end

  def show
    @section = Section.new
    @lesson = Lesson.new
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :cost, :image)
  end

  helper_method :current_course
  def current_course
    @current_course ||= Course.find(params[:id]) 
  end

  helper_method :current_section
  def current_section
    @current_section = Section.find(params[:id])
  end
  
  def require_authorized_for_current_course
    if current_user != current_course.user
      render plain: "Unauthorized", status: :unauthorized
    end
  end
  
end
