require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')
require_relative('db/sql_runner')
require('pry-byebug')

Ticket.delete_all()
Screening.delete_all()
Film.delete_all()
Customer.delete_all()

#---------------
# CUSTOMER SETUP
#---------------

customer1 = Customer.new({
  'name' => 'Brian',
  'funds' => 20
  })

customer2 = Customer.new({
 'name' => 'Ally',
 'funds' => 30
  })

customer3 = Customer.new({
  'name' => 'Upul',
  'funds' => 10
   })

customer1.save()
customer2.save()
customer3.save()

#---------------
# FILM SETUP
#---------------

film1 = Film.new({
  'title' => 'A Quiet Place',
  'price' => 10
  })

film2 = Film.new({
  'title' => 'Black Panther',
  'price' => 15
  })

film3 = Film.new({
  'title' => 'The Shape of Water',
  'price' => 20
  })

film1.save()
film2.save()
film3.save()

#---------------
# SCREENING SETUP
#---------------

screening1 = Screening.new({
 'timing' => '18.00',
 'capacity' => 5,
 'film_id' => film2.id
 })

screening2 = Screening.new({
 'timing' => '20.00',
 'capacity' => 5,
 'film_id' => film1.id
 })

screening3 = Screening.new({
 'timing' => '22.00',
 'capacity' => 5,
 'film_id' => film1.id
 })

screening4 = Screening.new({
 'timing' => '19.00',
 'capacity' => 3,
 'film_id' => film2.id
 })

screening5 = Screening.new({
 'timing' => '18.00',
 'capacity' => 2,
 'film_id' => film3.id
 })

screening6 = Screening.new({
 'timing' => '20.00',
 'capacity' => 2,
 'film_id' => film3.id
 })

screening1.save()
screening2.save()
screening3.save()
screening4.save()
screening5.save()
screening6.save()

#--------------
# TICKET SETUP
#--------------

ticket1 = Ticket.new({
 'customer_id' => customer1.id,
 'screening_id' => screening1.id
 })

ticket2 = Ticket.new({
 'customer_id' => customer1.id,
 'screening_id' => screening2.id
 })

ticket3 = Ticket.new({
 'customer_id' => customer1.id,
 'screening_id' => screening3.id
 })

ticket4 = Ticket.new({
 'customer_id' => customer2.id,
 'screening_id' => screening2.id
 })

ticket5 = Ticket.new({
 'customer_id' => customer2.id,
 'screening_id' => screening3.id
 })

ticket6 = Ticket.new({
 'customer_id' => customer3.id,
 'screening_id' => screening1.id
 })

ticket7 = Ticket.new({
 'customer_id' => customer3.id,
 'screening_id' => screening2.id
 })

ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()
ticket6.save()
ticket7.save()

binding.pry
nil
