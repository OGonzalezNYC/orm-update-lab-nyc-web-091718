require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade) #This method initializes a new instance without saving it to the db.
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save #This method saves an instance to the db.
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade) #This method initializes an instance AND saves it to the table, in case we wish to do both at once.
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?;
      SQL
      #DB[:conn].execute(sql)
      row = DB[:conn].execute(sql, name)[0]
      self.new_from_db(row)
  end

  def update
    sql = "UPDATE students SET id = ?, name = ?, grade = ?;"
    DB[:conn].execute(sql, self.id, self.name, self.grade)

  end

end

# attributes
#     has a name and a grade (FAILED - 1)
#     has an id that defaults to `nil` on initialization (FAILED - 2)
#   .create_table
#     creates the students table in the database (FAILED - 3)
#   .drop_table
#     drops the students table from the database (FAILED - 4)
#   #save
#     saves an instance of the Student class to the database and then
#               sets the given students `id` attribute (FAILED - 5)
#     updates a record if called on an object that is already persisted
#           (FAILED - 6)
#   .create
#     creates a student object with name and grade attributes (FAILED - 7)
#   .new_from_db
#     creates an instance with corresponding attribute values (FAILED - 8)
#   .find_by_name
#     returns an instance of student that matches the name from the DB (FAILED - 9)
#   #update
#     updates the record associated with a given instance (FAILED - 10)
