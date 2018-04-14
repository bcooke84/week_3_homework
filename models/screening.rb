require_relative("../db/sql_runner")
require_relative("customer.rb")
require_relative("ticket.rb")
require_relative("film.rb")

class Screening

  attr_reader :id
  attr_accessor :timing, :capacity, :film_id

  def initialize(options)
    @id = options['id'].to_i if options["id"]
    @timing = options['timing']
    @capacity = options['capacity'].to_i
    @film_id = options['film_id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql, values)
    return Screenings.map_screenings(screenings)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO screenings (timing, capacity, film_id) VALUES ($1, $2, $3) RETURNING id;"
    values = [@timing, @capacity, @film_id]
    screening = SqlRunner.run(sql, values).first()
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (timing, capacity, ticket_id, film_id) VALUES ($1, $2, $3) WHERE id = $4;"
    values = [@timing, @capacity, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.map_screenings(screening_data)
    return screening_data.map{ |screening_hash| Screening.new(screening_hash) }
  end

  # WRITE A METHOD THAT FINDS OUT WHAT IS THE MOST POPULAR TIME (MOST TICKETS SOLD) FOR A GIVEN FILM

  # def 
  #
  # end

end
