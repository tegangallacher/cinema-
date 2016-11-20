require_relative("../db/sql_runner")


class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ('#{ @name }', #{@funds}) RETURNING id;"
    customer = SqlRunner.run( sql ).first
    @id = customer['id'].to_i
  end

  def update
    return unless @id
    sql = "UPDATE customers SET
          (name, funds) = 
          ('#{@name}', #{funds})
          WHERE id = #{@id};"
    result = SqlRunner.run(sql)
  end

  def delete()
    return unless @id
    sql = "DELETE FROM customers WHERE id = #{id};"
    result = SqlRunner.run(sql)
  end

  def self.delete_all
    sql = "DELETE FROM customers;"
    result = SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM customers;"
    result = SqlRunner.run(sql)
    return result.map{|hash|Customer.new(hash)}
  end

    def film()
      sql ="SELECT f.* FROM films f
      INNER JOIN tickets t 
      ON f.id = t.film_id
      WHERE t.customer_id = #{@id};"
      films = Film.get_many(sql)
      return films
    end

    def tickets
    sql = "SELECT films.*, tickets.* FROM films 
    INNER JOIN tickets 
    ON tickets.film_id = films.id 
    WHERE customer_id = #{@id};"
    results = SqlRunner.run(sql)
    return results.map {|result| Ticket.new(result)}
  end

    def Customer.get_many(sql)
      customers = SqlRunner.run(sql)
      result = customers.map { |customer| Customer.new( customer ) }
      return result
    end

end