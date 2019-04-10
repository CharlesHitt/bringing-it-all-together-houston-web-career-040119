require 'pry'

class Dog
    attr_accessor :name, :breed, :id
    def initialize(name:, breed:, id: nil)
        @name = name
        @breed = breed
        @id = id
      
    end

    def self.create_table
        DB[:conn].execute('CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, breed TEXT)')
    end

    def self.drop_table
        DB[:conn].execute('DROP TABLE dogs')
    end

    def self.create(name:, breed:)
        dog = Dog.new(name: name,breed: breed)
        dog.save
        dog
        # Dog.new(id: dog[0], name: dog[1], breed: dog[2])
        # DB[:conn].execute('INSERT INTO dogs (name, breed) VALUES (?,?)',[name,breed])
    end

    # def find_by_id(id)
    #     dog = DB[:conn].execute('SELECT * FROM dogs WHERE id = ?',[id]).flatten
    #     dog_hash = {id:dog[0],name:dog[1],breed:dog[2]}
    #     Dog.new(dog_hash)
        
    # end



    def self.new_from_db(dog)
    #    binding.pry
        # DB[:conn].execute('INSERT INTO dogs (id,name,breed) VALUES (?,?,?)', [id: dog[0],name: dog[1], breed: dog[2]])
        Dog.new(id: dog[0],name: dog[1], breed: dog[2])
        # binding.pry
    end

    def self.find_by_name(name)
        DB[:conn].execute('SELECT * FROM dogs WHERE name = ?',[name])
    end

    def update(name,breed)
        self.name = name
        self.breed = breed
        DB[:conn].execute('UPDATE dogs SET name = ?, breed = ? WHERE id = ?', [name,breed,self.id])
    end

    def save
        if self.id
            self.update
        else
            DB[:conn].execute('INSERT INTO dogs(name,breed) VALUES(?,?)',[name,breed])
        end
        self
    end


    def self.find_by_name(name)
        sql = <<-SQL
          SELECT *
          FROM dogs
          WHERE name = ?
          LIMIT 1
        SQL
    
        DB[:conn].execute(sql,name).map do |row|
          self.new_from_db(row)
        end.first
    end
    
    def self.find_by_id(id)
        sql = <<-SQL
          SELECT *
          FROM dogs
          WHERE id = ?
          LIMIT 1
        SQL
    
        DB[:conn].execute(sql,id).map do |row|
          self.new_from_db(row)
        end.first
    end
    
   def self.find_or_create_by(name:,breed:)
        if self.id
            self.update
        elsif self.new(id: dog[0],name: dog[1], breed: dog[2])
        else DB[:conn].execute('SELECT * FROM dogs WHERE name,breed = (?,?)', [name,breed])
        end
   end
       

#   binding.pry
#   0
end
