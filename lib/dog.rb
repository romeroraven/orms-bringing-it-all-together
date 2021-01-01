
class Dog

    attr_accessor :name, :breed
    attr_reader :id
    
    def initialize name:, breed:, id: nil
        @id = id
        @name = name
        @breed = breed
    end
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        SQL
        DB[:conn].execute(sql)
        end

        def self.drop_table
            sql = <<-SQL
            DROP TABLE dogs;
            SQL
            DB[:conn].execute(sql)
        end

        def save
            if self.id
                self.return
            else 
                sql = <<-SQL
                INSERT INTO dogs (name, breed) VALUES (?, ?)
                SQL
                DB[:conn].execute(sql, self.name, self.breed)
                @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
                self
            end
        end

        def self.create (new)
            name = new[:name]
            breed = new[:breed]
            new_dog = self.new(name: name, breed: breed)
            new_dog.save
        end

        def self.new_from_db (new)
            id = new[0]
            name = new[1]
            breed = new[2]
            new_dog = Dog.new(id: id, name: name, breed: breed)
        end

        def self.find_by_id
            sql = <<-SQL
            SELECT *
            FROM dogs
            WHERE id = ?;
            SQL
            id = DB[:conn].execute(sql, name)
            self.new_from_db(id[0])
        end

        def self.find_or_create_by

        end
        
        def self.find_by_name
            sql = <<-SQL
            SELECT *
            FROM dogs
            WHERE name = ?;
            SQL
            self.new_from_db(DB[:conn].execute(sql, name).flatten)
        end

        def update
            sql = <<-SQL
            UPDATE dogs SET name = ?, breed = ? WHERE id = ?;
            SQL
            DB[:conn].execute(sql, self.name, self.breed, self.id)
        end
end