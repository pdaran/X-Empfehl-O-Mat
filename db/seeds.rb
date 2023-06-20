# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: ENV.fetch("INITIAL_ADMIN_EMAIL"), password: ENV.fetch("INITIAL_ADMIN_PASSWORD"), admin: true)

shop = Shop.create!(name: "DevShop", email: ENV.fetch("INITIAL_ADMIN_EMAIL"), password: ENV.fetch("INITIAL_ADMIN_PASSWORD"), address: "abcdefg", phone_no: "012345678912", status: "active")

category = shop.categories.create!(title: "TestKategorie", status: :active)

category.products.create!(product: "Test Produkt", desc: "Test Beschreibung Nummer 1", status: :public)
category.products.create!(product: "Anderes Produkt", desc: "Andere Beschreibung Nummer 2", status: :public)
