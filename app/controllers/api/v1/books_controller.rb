require 'zip'

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

  def export
    # Attachment name
    filename = "user-#{current_user.id}-exported-books-#{Date.today.strftime('%d-%m-%Y')}.zip"
    temp_file = Tempfile.new(filename)

    stringio = Zip::OutputStream.write_buffer do |zio|
      books.each do |b|
        sanitized_book_name = sanitize(b.name)
        b.notes.each do |n|
          zio.put_next_entry("#{sanitized_book_name}/#{sanitize(n.title)}.pdf")
          zio << n.to_pdf
        end
      end
    end
    stringio.rewind
    binary_data = stringio.sysread
    send_data(binary_data, type: 'application/zip', filename: filename)
  end

  def export_book
    # Attachment name
    filename = "#{sanitize(book.name)}-export-#{Date.today.strftime('%d-%m-%Y')}.zip"
    temp_file = Tempfile.new(filename)

    stringio = Zip::OutputStream.write_buffer do |zio|
      notes.each do |n|
        # create and add a pdf file for this record
        zio.put_next_entry(sanitize("#{n.title}.pdf"))
        zio << n.to_pdf
      end
    end
    stringio.rewind
    binary_data = stringio.sysread
    send_data(binary_data, type: 'application/zip', filename: filename)
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
