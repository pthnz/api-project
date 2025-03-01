require "digest"

class StudentsController < ApplicationController
  SECRET_SALT = "02960c867f22dc3ca9ade43aaf85f28c5138f59201573de5ec2469cd222486f8"

  before_action :authenticate_request, only: [ :destroy ]
  before_action :set_student, only: [ :destroy ]

  def index
    students = Student.where(school_id: params[:school_id], class_id: params[:class_id])
                 .select(:id, :first_name, :last_name, :school_id, :class_id)

    if students.exists?
      render json: { data: students }, status: :ok
    else
      render json: { error: "Студент для данной школы и класса не найдены" }, status: :not_found
    end
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      token = generate_token(@student.id)
      response.set_header("X-Auth-Token", token)
      render json: token, status: :created
    else
      render json: { error: @student.errors.full_messages }, status: :method_not_allowed
    end
  end

  def destroy
    if @student.destroy
      render json: { result: "Студент удален" }, status: :ok
    else
      render json: { error: "Unable to delete student" }, status: :bad_request
    end
  end

  private

  def authenticate_request
    token = request.headers["X-Auth-Token"]

    @student = Student.find_by(id: params[:id])

    unless @student
      render json: { error: "Некорректный id студента" }, status: :bad_request
      return
    end

    expected_token = generate_token(id: params[:id])

    unless token != expected_token
      render json: { error: "Некорректная авторизация" }, status: :unauthorized
    end
  end

  def set_student
    @student = Student.find(params[:id])
    unless @student
      render json: { error: "Некорректный id студента" }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Некорректный id студента" }, status: :bad_request
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :surname, :class_id, :school_id)
  end

  def generate_token(student_id)
    Digest::SHA256.hexdigest("#{student_id}#{SECRET_SALT}")
  end
end
