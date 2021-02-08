require 'swagger_helper'

describe 'API V1 Notes', swagger_doc: 'v1/swagger.json' do
  path '/notes' do
    get 'Retrieves Notes' do
      description 'Retrieves all the notes'
      produces 'application/json'

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before { create_list(:note, collection_count) }

      response '200', 'Notes retrieved' do
        schema('$ref' => '#/definitions/notes_collection')

        run_test! do |response|
          expect(JSON.parse(response.body)['data'].count).to eq(expected_collection_count)
        end
      end
    end

    post 'Creates Note' do
      description 'Creates Note'
      consumes 'application/json'
      produces 'application/json'
      parameter(name: :note, in: :body)

      response '201', 'note created' do
        let(:note) do
          {
            title: 'Some title',
            content: 'Some content',
            user_id: 222,
            book_id: 666
          }
        end

        run_test!
      end
    end
  end

  path '/notes/{id}' do
    parameter name: :id, in: :path, type: :integer

    let(:existent_note) { create(:note) }
    let(:id) { existent_note.id }

    get 'Retrieves Note' do
      produces 'application/json'

      response '200', 'note retrieved' do
        schema('$ref' => '#/definitions/note_resource')

        run_test!
      end

      response '404', 'invalid note id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates Note' do
      description 'Updates Note'
      consumes 'application/json'
      produces 'application/json'
      parameter(name: :note, in: :body)

      response '200', 'note updated' do
        let(:note) do
          {
            title: 'Some title',
            content: 'Some content',
            user_id: 222,
            book_id: 666
          }
        end

        run_test!
      end
    end

    delete 'Deletes Note' do
      produces 'application/json'
      description 'Deletes specific note'

      response '204', 'note deleted' do
        run_test!
      end

      response '404', 'note not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
