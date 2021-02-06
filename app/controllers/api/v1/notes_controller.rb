class Api::V1::NotesController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    respond_with notes
  end

  def show
    respond_with note
  end

  def create
    if params['user_id'].eql?(current_user.id)
      respond_with Note.create!(note_params)
    else
      respond_api_error(:bad_request, message: 'bad request', detail: 'user_id != current user id')
    end
  end

  def update
    respond_with note.update!(note_params)
  end

  def destroy
    respond_with note.destroy!
  end

  def export
    send_data note.to_pdf, filename: "#{sanitize(note.book.name)}-#{sanitize(note.title)}.pdf", type: :pdf
  end

  private

  def note
    @note ||= current_user.notes.find_by!(id: params[:id])
  end

  def notes
    @notes ||= current_user.notes
  end

  def note_params
    params.require(:note).permit(
      :title,
      :content,
      :color,
      :user_id,
      :book_id
    )
  end
end
