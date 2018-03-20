require 'csv'
require 'date'

class FileHandler

  DEFAULT_CSV_OPTIONS = { :col_sep => "\t", :headers => :first_row, :row_sep => "\r\n" }
  BASE_PATH = "#{Dir.pwd}/workspace/"
  LINES_PER_FILE = 120000


  def initialize(filename, path = BASE_PATH, column = 'Clicks', csv_options = DEFAULT_CSV_OPTIONS)
    @column = column
    @filename = filename
    @input_path = "#{path}/input"
    @output_path = "#{path}/output"
    @csv_options = csv_options
  end


  def latest
    files = Dir["#{ @input_path }/*#{@filename}*.txt"]

    files.sort_by! do |file|
      last_date = /\d+-\d+-\d+_[[:alpha:]]+\.txt$/.match file
      last_date = last_date.to_s.match /\d+-\d+-\d+/

      date = DateTime.parse(last_date.to_s) if not last_date.nil?
      date
    end

    throw RuntimeError if files.empty?

    @file = files.last

    self
  end


  def parse
    CSV.read(@file, @csv_options)
  end


  def lazy_read
    Enumerator.new do |yielder|
      CSV.foreach(@file,  @csv_options) do |row|
        yielder.yield(row)
      end
    end
  end



  def write(content, headers, output)
    CSV.open(output, "wb",  @csv_options) do |csv|
      csv << headers
      content.each do |row|
        csv << row
      end
    end
  end


  def sort
    output = get_outputname('','txt.sorted')
    content_as_table = parse
    headers = content_as_table.headers
    index_of_key = headers.index('Clicks')
    content = content_as_table.sort_by { |a| -a[index_of_key].to_i }
    write(content, headers, output)
    @file = output
    self
  end


  def output_data(merged_data)
    done = false
    file_index = 0
    while not done do
      sorted_file = "#{get_outputname("_#{file_index}")}"
      CSV.open(sorted_file, 'wb', @csv_option) do |csv|
        headers_written = false
        line_count = 0
        while line_count < LINES_PER_FILE
          begin
            merged = merged_data.next
            if not headers_written
              csv << merged.keys
              headers_written = true
              line_count += 1
            end
            csv << merged.values
            line_count += 1
          rescue StopIteration
            done = true
            break
          end
        end
        file_index += 1
      end
    end
  end

  def get_outputname(suffix = '', ext = 'txt')
    "#{@output_path}/#{@filename}#{suffix}.#{ext}"
  end
end