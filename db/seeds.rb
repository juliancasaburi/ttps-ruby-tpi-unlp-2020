# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

5.times do |i|
  new_user = User.new email: "user#{i}@ruby.notes", password: "rubynotes", password_confirmation: "rubynotes"
  new_user.save
end

users = User.all

users.each do |user|
  # Create Books
  2.times do |j|
    book = user.books.create!(name: "book/#{j}")

    # Create notes
    2.times do |r|
      book.notes.create!(title: "red note #{r}", content: "#markDownTitle\n**bold text**", user_id: user.id, color: 'red accent-1')
    end
    2.times do |g|
      book.notes.create!(title: "green note #{g}", content: "#markDownTitle\n**bold text**", user_id: user.id, color: 'light-green accent-1')
    end
    2.times do |d|
      book.notes.create!(title: "default color note #{d}", content: "#markDownTitle\n**bold text**", user_id: user.id, color: 'default')
    end
  end

  # Add some notes to user global's book
  user_global_book = user.global_book
  2.times do |r|
    user_global_book.notes.create!(title: "global book red note #{r}", content: "#markDownTitle\n**bold text**", user_id: user.id,
                                   color: 'red accent-1')
  end
  2.times do |g|
    user_global_book.notes.create!(title: "global book green note #{g}", content: "#markDownTitle\n**bold text**", user_id: user.id,
                                   color: 'light-green accent-1')
  end
  2.times do |d|
    user_global_book.notes.create!(title: "global book default color note #{d}", content: "#markDownTitle\n**bold text**", user_id: user.id, color: 'default')
  end
end
