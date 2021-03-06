require_relative("../db/sql_runner")
require_relative("customer.rb")
require_relative("ticket.rb")
require_relative("screening.rb")

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
    films = SqlRunner.run(sql, values)
    return Film.map_films(films)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
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
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id INNER JOIN screenings ON screenings.id = tickets.screening_id INNER JOIN films ON films.id = screenings.film_id WHERE tickets.customer_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return Customer.map_customers(customers)
  end

  # CHECK HOW MANY CUSTOMERS ARE GOING TO WATCH A CERTAIN FILM (see how many tickets have been bought for a film)

  def tickets()
    sql = "SELECT tickets.* FROM films INNER JOIN screenings ON films.id = screenings.film_id INNER JOIN tickets ON screenings.id = tickets.screening_id WHERE film_id = $1;"
    values = [@id]
    films_hash = SqlRunner.run(sql, values)
    return Film.map_films(films_hash).count
  end

  def show_films_screening_timing()
    sql = "SELECT screenings.*, films.title FROM films INNER JOIN screenings ON screenings.film_id = films.id WHERE film_id = $1"
    values = [@id]
    film_hash = SqlRunner.run(sql, values)
    return Screening.map_screenings(film_hash)
  end


end
