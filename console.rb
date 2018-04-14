require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

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


film1 = Film.new({
  'title' => 'A Quiet Place',
  'price' => 10
  })

  film1.save()

film2 = Film.new({
  'title' => 'Black Panther',
  'price' => 15
  })

  film2.save()

film3 = Film.new({
  'title' => 'The Shape of Water',
  'price' => 20
  })

  film3.save()

  ticket1 = Ticket.new({
   'customer_id' => customer1.id,
   'film_id' => film1.id
   })

  ticket2 = Ticket.new({
   'customer_id' => customer1.id,
   'film_id' => film2.id
   })

  ticket3 = Ticket.new({
   'customer_id' => customer1.id,
   'film_id' => film3.id
   })

  ticket4 = Ticket.new({
   'customer_id' => customer2.id,
   'film_id' => film2.id
   })

  ticket5 = Ticket.new({
   'customer_id' => customer2.id,
   'film_id' => film3.id
   })

  ticket6 = Ticket.new({
   'customer_id' => customer3.id,
   'film_id' => film1.id
   })

  ticket7 = Ticket.new({
   'customer_id' => customer3.id,
   'film_id' => film1.id
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
