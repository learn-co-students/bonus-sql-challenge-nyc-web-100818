class CsvSQLiteBuilder
  attr_reader :csv_file_path, :table_name, :date_format

  # only two datatypes for simplicity, could be extended
  DATA_TYPES = { integer: "INTEGER", string: "TEXT" }

  def initialize(args)
    @csv_file_path = args[:csv_file_path]
    @table_name = args[:table_name]
    @date_format = args[:date_format]
  end

  # checks through the file to build columns hash
  def analyze(rows)
    row_index = 0
    CSV.foreach(self.csv_file_path) do |row|
      if row_index == 0 # create column definitions from header
        row.each_with_index do |cell, cell_index| # include cell index to lookup from other rows
          CsvColumn.new(name: cell, index: cell_index)
        end
      elsif row_index <= rows # analyze X rows of data
        row.each_with_index do |cell, cell_index|
          column = CsvColumn.find_by_index(cell_index) # find CsvColumn instance with same index
          if column
            data_type = get_data_type(cell)
            if column.data_types[data_type]
              column.data_types[data_type] += 1 # increment counter
            else
              column.data_types[data_type] = 1
            end
          else
            begin
              raise RowAnalyzeError
            rescue RowAnalyzeError => error
              puts error.message + " | Row index: #{row_index}. Row data: #{row}"
            end
          end
        end
      end
      row_index += 1
    end
  end

  # analyze data type
  def get_data_type(value)
    if value.to_i.to_s == value # integer
      DATA_TYPES[:integer]
    else
      DATA_TYPES[:string]
    end
  end

  # creates table SQL
  def create_table
    create_string = self.build_sql_create_string
    if create_string
      DB[:conn].execute(create_string)
    else
      raise CreateTableError
    end
  end

  def build_sql_create_string
    column_defs = []
    column_defs << "  id INTEGER PRIMARY KEY" # add id column
    CsvColumn.all.each do |column|
      column_defs << "  #{column.name} #{column.data_type}"
    end
    <<-SQL
      CREATE TABLE IF NOT EXISTS #{self.table_name} (
        #{column_defs.join(",\n")}
      );
    SQL
  end

  def insert_row_data
    # build insert_data strings
    column_names = CsvColumn.column_names.join(", ")
    bind_params = CsvColumn.column_names.count.times.collect{"?"}.join(", ")
    sql = <<-SQL
      INSERT INTO #{self.table_name} (#{column_names})
      VALUES (#{bind_params})
    SQL
    header_row = true
    # headers: true makes each row a CSV::Row class
    # https://www.sitepoint.com/guide-ruby-csv-library-part-2/
    CSV.foreach(self.csv_file_path) do |row|
      if !header_row # ignore header
        params = get_insert_params(row)
        DB[:conn].execute(sql, *params) # add error handling
      end
      header_row = false
    end
  end

  def get_insert_params(row)
    row.each_with_index.map{|cell, index|
      get_insert_value(cell, index)
    }
  end

  def get_insert_value(cell, index)
    data_type = CsvColumn.find_by_index(index).data_type # lookup datatype
    if data_type == DATA_TYPES[:string] # check if datatype is string
      parsed_date = Date.strptime(cell, self.date_format) rescue nil
      if parsed_date
        cell = parsed_date.strftime("%Y-%m-%d") # try to parse string dates to SQLite YYYY-MM-DD format
      end
    end

    cell
  end

  class RowAnalyzeError < StandardError
    def message
      "Error analyzing row data."
    end
  end

  class CreateTableError < StandardError
    def message
      "Error creating table definition!"
    end
  end
end
