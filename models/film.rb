require_relative("../db/sql_runner")
require_relative("customer.rb")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end

  def self.all()
    sql = "SELECT * FROM films;"
    values = []
    films = SqlRunner.run(sql, values)
    return Film.map_films(films)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id;"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first()
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_films(film_data)
    return film_data.map { |film_hash| Film.new(film_hash) }
  end

  # SELECT ALL THE CUSTOMERS THAT HAVE WATCHED A FILM
  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.film_id WHERE tickets.customer_id = $1;"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return Customer.map_customers(customers)
  end

  # CHECK HOW MANY CUSTOMERS ARE GOING TO WATCH A CERTAIN FILM (see how many tickets have been bought for a film)

  def tickets()
    sql = "SELECT * FROM tickets WHERE film_id = $1;"
    values = [@id]
    films_hash = SqlRunner.run(sql, values)
    return Film.map_films(films_hash).count
  end



end
