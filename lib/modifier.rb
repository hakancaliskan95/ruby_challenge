class Modifier

  KEYWORD_UNIQUE_ID = 'Keyword Unique ID'

  def initialize(saleamount_factor, cancellation_factor)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
  end

  def modify(*input_enumerator)


    combiner = Combiner.new do |value|
      value[KEYWORD_UNIQUE_ID]
    end.combine(*input_enumerator)


    combine = CombineValues.new(@saleamount_factor,@cancellation_factor)
    Enumerator.new do |yielder|
      while true
        begin
          list_of_rows = combiner.next
          merged = combine.combine_values(list_of_rows)
          yielder.yield(merged)
        rescue StopIteration
          break
        end
      end
    end

  end


  def combine(merged)
    result = []
    merged.each do |_, hash|
      result << combine_values(hash)
    end
    result
  end


end