Dir['./lib/*.rb'].each {|f| require f }


modification_factor = 1
cancellaction_factor = 0.4

file = FileHandler.new('project_2012-07-27_2012-10-10_performancedata')

modifier = Modifier.new(modification_factor, cancellaction_factor)
data = modifier.modify(file.latest.sort.lazy_read)
file.output_data(data)
puts "DONE modifying"
