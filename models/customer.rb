require_relative("../db/sql_runner")
require_relative("film.rb")
require_relative("ticket.rb")
require_relative("screening.rb")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    customers = SqlRunner.run(sql)
    return Customer.map_customers(customers)
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id;"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first()
    @id = customer["id"].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_customers(customer_data)
    return customer_data.map { |customer_hash| Customer.new(customer_hash) }
  end

  # RETURN ALL THE FILMS THAT A CUSTOMER HAS WATCHED
  def films()
    sql = "SELECT films.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id INNER JOIN screenings ON screenings.id = tickets.screening_id INNER JOIN films ON films.id = screenings.film_id WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return Film.map_films(films)
  end

  # BUYING TICKETS SHOULD DECREASE THE FUNDS OF THE CUSTOMER BY THE PRICE
  
  def price_check(film)
    return @funds >= film.price
  end

  def deduct_funds(purchase)
    @funds -= purchase
  end

  def buy_ticket(film, screening)
    if price_check(film) == true
      new_ticket = Ticket.new({ 'customer_id' => @id, 'screening_id' => screening.id }).save
      deduct_funds(film.price)
      update()
    else
      return false
    end
  end

# CHECK HOW MANY TICKETS WERE BOUGHT BY A CUSTOMER

  def tickets()
    sql = "SELECT * FROM tickets WHERE customer_id = $1;"
    values = [@id]
    tickets_hash = SqlRunner.run(sql, values)
    return Ticket.map_tickets(tickets_hash).count
  end


end
