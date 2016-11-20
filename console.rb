require ('pry-byebug')
require_relative ('models/customer')
require_relative ('models/film')
require_relative ('models/ticket')

Ticket.delete_all
Customer.delete_all
Film.delete_all



film1 = Film.new({
  "title" =>"Lost in Translation",
  "price" => 10
  })
film1.save

film2 = Film.new({
  "title" =>"American Beauty",
  "price" => 10
  })
film2.save

customer1 = Customer.new({
  "name" => "Bill Murray",
  "funds" => 20
  })
customer1.save

customer2 = Customer.new({
  "name" => "Kevin Spacey",
  "funds" => 20
  })
customer2.save

ticket1 = Ticket.new({
  "customer_id" => customer1.id,
  "film_id" => film1.id
  })
ticket1.save

# customer1.name = "Tegan Gallacher"
# customer1.update

customers = Customer.all
films = Film.all
tickets = Ticket.all


binding.pry
nil