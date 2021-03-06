require_relative("../db/sql_runner")
require_relative("customer.rb")
require_relative("screening.rb")
require_relative("film.rb")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, screening_id) VALUES ($1, $2) RETURNING id;"
    values = [@customer_id, @screening_id]
    ticket = SqlRunner.run(sql, values).first()
    @id = ticket['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return Ticket.map_tickets(tickets)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def update() # WOULD THIS ACTUALLY BE REQUIRED?
    sql = "UPDATE tickets SET (customer_id, screening_id) = ($1, $2) WHERE id = $3;"
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_tickets(ticket_data)
    return ticket_data.map { |ticket_hash| Ticket.new(ticket_hash) }
  end

end
