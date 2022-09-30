# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

%w[merchants shoppers orders].each do |record_type|
  data = File.read(Rails.root.join("dataset/#{record_type}.json"))
  records = JSON.parse(data, symbolize_names: true)[:RECORDS]
  model_class = record_type.singularize.titlecase.constantize

  model_class.insert_all(records)
end
