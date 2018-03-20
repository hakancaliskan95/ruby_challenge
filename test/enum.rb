require 'csv'

DEFAULT_CSV_OPTIONS = { :col_sep => "\t", :headers => :first_row }
def lazy_read(file)
  Enumerator.new do |yielder|
    CSV.foreach(file, DEFAULT_CSV_OPTIONS) do |row|
      yielder.yield(row)
    end
  end
end

file = "#{ File.dirname(__FILE__) }/../csv/project_2012-07-27_2012-10-10_performancedata.txt"

enumerators = lazy_read(file)
puts enumerators.size
last_values = Array.new(10)
