require_relative("../db/sql_runner")


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize( options )
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ('#{ @title }', #{@price}) RETURNING id;"
    film = SqlRunner.run( sql ).first
    @id = film['id'].to_i
  end

  def update
    return unless @id
    sql = "UPDATE films SET
          (title, price) = 
          ('#{@title}', #{@price})
          WHERE id = #{@id};"
    result = SqlRunner.run(sql)
  end

  def delete()
    return unless @id
    sql = "DELETE FROM films WHERE id = #{id};"
    result = SqlRunner.run(sql)
  end

  def self.delete_all
    sql = "DELETE FROM films;"
    result = SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM films;"
    result = SqlRunner.run(sql)
    return result.map{|hash|Film.new(hash)}
  end

    def customers()
      sql ="SELECT c.* FROM customers c
      INNER JOIN tickets t 
      ON c.id = t.customer_id
      WHERE t.film_id = #{@id};"
      customers = Film.get_many(sql)
      return customers
    end

    def tickets
    sql = "SELECT customers.*, tickets.* FROM customers
    INNER JOIN tickets 
    ON tickets.customer_id = customers.id 
    WHERE film_id = #{@id};"
    results = SqlRunner.run(sql)
    return results.map {|result| Ticket.new(result)}
  end

    def Film.get_many(sql)
      films = SqlRunner.run(sql)
      result = films.map { |film| Film.new( film ) }
      return result
    end

end