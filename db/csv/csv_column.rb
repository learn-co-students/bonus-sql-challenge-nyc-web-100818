class CsvColumn
  attr_reader :name, :index, :data_types, :insertable

  @@all = []
  def initialize(args)
    self.name = args[:name]
    @index = args[:index]
    @data_types = {} # { "INGEGER" => 2, "TEXT" => 1 }
    @@all << self
  end

  # set valid column names
  def name=(name)
    name.gsub!(/\s/,"_") # replace whitespace with underscores
    name.gsub!(/\W/, "") # remove non word characters (letter, number, underscore)
    name = "#{name}_" if KEYWORDS.include?(name.upcase) # append _ to column names that are SQLite keywords
    @name = name.downcase
  end

  # returns string key of data_types hash for highest value (from analyze)
  def data_type
    self.data_types.max_by{|type,count| count}[0]
  end

  def self.all
    @@all
  end

  def self.column_names
    self.all.map{|column| column.name}
  end

  def self.find_by_index(index)
    self.all.find{|column| column.index == index}
  end
end
