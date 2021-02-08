require 'swagger_helper'

describe 'API V1 Books', swagger_doc: 'v1/swagger.json' do
  path '/books' do
    get 'Retrieves Books' do
      description 'Retrieves all the books'
      produces 'application/json'

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before { create_list(:book, collection_count) }

      response '200', 'Books retrieved' do
        schema('$ref' => '#/definitions/books_collection')

        run_test! do |response|
          expect(JSON.parse(response.body)['data'].count).to eq(expected_collection_count)
        end
      end

      response '401', 'user unauthorized' do
        let(:user_token) { 'invalid' }
      
        run_test!
      end
    end

    post 'Creates Book' do
      description 'Creates Book'
      consumes 'application/json'
      produces 'application/json'
      parameter(name: :book, in: :body)

      response '201', 'book created' do
        let(:book) do
          {
            name: 'Some name'
          }
        end

        run_test!
      end

      response '400', 'invalid attributes' do
        let(:book) do
          {
            name: nil
          }
        end

        run_test!
      end
    end
  end

  path '/books/{id}' do
    parameter name: :id, in: :path, type: :integer

    let(:existent_book) { create(:book) }
    let(:id) { existent_book.id }

    get 'Retrieves Book' do
      produces 'application/json'

      response '200', 'book retrieved' do
        schema('$ref' => '#/definitions/book_resource')

        run_test!
      end

      response '404', 'invalid book id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates Book' do
      description 'Updates Book'
      consumes 'application/json'
      produces 'application/json'
      parameter(name: :book, in: :body)

      response '200', 'book updated' do
        let(:book) do
          {
            name: 'Some name'
          }
        end

        run_test!
      end

      response '400', 'invalid attributes' do
        let(:book) do
          {
            name: nil
          }
        end

        run_test!
      end
    end

    delete 'Deletes Book' do
      produces 'application/json'
      description 'Deletes specific book'

      response '204', 'book deleted' do
        run_test!
      end

      response '404', 'book not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
