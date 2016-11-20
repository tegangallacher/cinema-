require_relative("../db/sql_runner")
require_relative("film")
require_relative("customer")


class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize( options )
    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end


  def save()
    sql = "INSERT INTO tickets (customer_id, film_id)
           VALUES (#{ @customer_id }, #{ @film_id }) RETURNING id;"
    ticket = SqlRunner.run( sql ).first
    @id = ticket['id'].to_i
  end

  def update
    return unless @id
    sql = "UPDATE tickets SET
          (customer_id, film_id) = 
          ('#{@customer_id}', #{film_id})
          WHERE id = #{@id};"
    result = SqlRunner.run(sql)
  end

  def delete()
    return unless @id
    sql = "DELETE FROM tickets WHERE id = #{id};"
    result = SqlRunner.run(sql)
  end

  def self.delete_all
    sql = "DELETE FROM tickets;"
    result = SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM tickets;"
    result = SqlRunner.run(sql)
    return result.map{|hash|Ticket.new(hash)}
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = #{@customer_id};"
    customer = SqlRunner.run(sql).first
    return Customer.new(customer)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = #{@film_id};"
    film = SqlRunner.run(sql).first
    return Film.new(film)
  end

end