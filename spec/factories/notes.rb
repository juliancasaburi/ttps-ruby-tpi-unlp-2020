FactoryBot.define do
  factory :note do
    title { "MyString" }
    content { "MyText" }
    book { nil }
  end
end
