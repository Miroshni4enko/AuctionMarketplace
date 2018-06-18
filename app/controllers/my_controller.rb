# frozen_string_literal: true

class MyController < ApiController
  before_action :check_criteria

  def index
    my_lots = Lot.filter_by_criteria_and_user_id(@criteria, current_user.id).page(my_params[:page])
    render_collection my_lots, each_serializer: LotSerializer
  end

  private

    def my_params
      params.permit(:filter, :page)
    end

    def check_criteria
      criteries = %w(participation all created)
      criteria =  my_params[:filter]
      if  criteries.include? criteria
        @criteria = criteria
      else
        render status: :bad_request
      end
    end
end
