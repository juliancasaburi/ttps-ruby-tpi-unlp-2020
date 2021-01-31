class Api::V1::BooksController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    respond_with books
  end

  def show
    respond_with book
  end

  def create
    if params['user_id'].eql?(current_user.id)
      respond_with Book.create!(book_params)
    else
      respond_api_error(:bad_request, message: 'bad request', detail: 'user_id != current user id')
    end
  end

  def update
    if book.name.eql?('Global')
      respond_api_error(:bad_request, message: 'bad request', detail: 'Updating global book is not allowed.')
    else
      respond_with book.update!(book_params)
    end
  end

  def destroy
    if book.name.eql?('Global')
      respond_api_error(:bad_request, message: 'bad request', detail: 'Destroying global book is not allowed.')
    else
      respond_with book.destroy!
    end
  end

  def book_notes
    respond_with notes
  end

  private

  def book
    @book ||= current_user.books.find_by!(id: params[:id])
  end

  def books
    @books ||= current_user.books
  end

  def notes
    @notes ||= book.notes
  end

  def book_params
    params.require(:book).permit(
      :name,
      :user_id
    )
  end
end
