class SchoolClassesController < ApplicationController
  def index
    school = SchoolClass.where(school_id: params[:school_id])
                      .select(:id, :number, :letter, :students_count)

    if school.exists?
      render json: { data: school }, status: :ok
    else
      render json: { error: 'Нет добавленного класса' }, status: :not_found
    end
  end
end