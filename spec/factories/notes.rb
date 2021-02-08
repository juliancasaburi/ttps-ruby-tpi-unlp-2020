FactoryBot.define do
  factory :note do
    title { "MyString" }
    content { "MyText" }
    color { "none" }
    book { nil }
  end
end
