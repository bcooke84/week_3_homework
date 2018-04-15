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

  # CREATE A SCREENINGS TABLE THAT LETS US KNOW WHAT TIME FILMS ARE SHOWING

  def show_films_by_screening_timing()
    sql = "SELECT screenings.timing, films.title FROM films INNER JOIN screenings ON screenings.film_id = films.id ORDER BY screenings.timing WHERE id = $1"
    values = [@id]
    film_hash = SqlRunner.run(sql, values)
    return Film.map_films(film_hash)
  end

  # WRITE A METHOD THAT FINDS OUT WHAT IS THE MOST POPULAR SCREENING TIME (MOST TICKETS SOLD) FOR A GIVEN FILM

  def self.find_screenings_by_film_name(film)
    sql = "SELECT * FROM screenings WHERE screenings.film_id = $1"
    values = [film.id]
    screenings_hash = SqlRunner.run(sql, values)
    return Screening.map_screenings(screenings_hash)
  end

# ----------------------------------------------
# RETURNS NUMBER OF TICKETS AT BUSIEST SCREENING
# ----------------------------------------------

  def find_tickets_by_screening()
    sql = "SELECT * FROM tickets WHERE tickets.screening_id = $1"
    values = [@id]
    tickets_hash = SqlRunner.run(sql, values)
    return Ticket.map_tickets(tickets_hash).count
  end

  def self.find_most_popular_screening(film)
    screenings_array = Screening.find_screenings_by_film_name(film)
    count_array = []
    for screening in screenings_array
      count_array.push(screening.find_tickets_by_screening)
    end
    return count_array.max
  end

  # def find_tickets_by_screening()
  #   sql = "SELECT * FROM tickets WHERE tickets.screening_id = $1"
  #   values = [@id]
  #   tickets_hash = SqlRunner.run(sql, values)
  #   return Ticket.map_tickets(tickets_hash)
  # end

  # def self.find_most_popular_screening(film)
  #   screenings_array = Screening.find_screenings_by_film_name(film)
  #   count = 0
  #   array = []
  #   for screening in screenings_array
  #     sql = "SELECT * FROM tickets WHERE tickets.screening_id = $1"
  #     values = [screening.id]
  #     tickets_hash = SqlRunner.run(sql, values)
  #     puts tickets_hash
  #     array[count] = Ticket.map_tickets(tickets_hash)
  #     count += 1
  #   end
  #   puts tickets_hash
  #   puts array[0][@screening_id]
  #   puts
  #   puts array[1].count
  # end

end

# SELECT COUNT(*) FROM tickets WHERE screening_id = 61;
# sorted = prices.sort { |a, b| b <=> a }
# highest = sorted.first
