class CombineValues

  LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
  LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
  INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
  FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
  NUMBER_OF_COMMISSIONS = ['number of commissions']
  COMMISSION_VALUES = ['Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value', 'KEYWORD - Commission Value']

  def initialize(saleamount_factor,cancellation_factor)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
  end


  def combine_hashes(list_of_rows)
    keys = []
    list_of_rows.each do |row|
      next if row.nil?
      row.headers.each do |key|
        keys << key
      end
    end
    result = {}
    keys.each do |key|
      result[key] = []
      list_of_rows.each do |row|
        result[key] << (row.nil? ? nil : row[key])
      end
    end
    result
  end


  def last_value_wins
    LAST_VALUE_WINS.each do |key|
      @hash[key] = @hash[key].last
    end
    self
  end

  def last_real_value_wins
    LAST_REAL_VALUE_WINS.each do |key|
      @hash[key] = @hash[key].select {|v| not (v.nil? or v == 0 or v == '0' or v == '')}.last
    end
    self
  end

  def int_values
    INT_VALUES.each do |key|
      @hash[key] = @hash[key][0].to_s
    end
    self
  end

  def float_values

    FLOAT_VALUES.each do |key|
      @hash[key] = @hash[key][0].from_german_to_f.to_german_s
    end
    self
  end

  def number_of_commissions
    NUMBER_OF_COMMISSIONS.each do |key|
      @hash[key] = (@cancellation_factor * @hash[key][0].from_german_to_f).to_german_s
    end
    self
  end

  def commissions_values
    COMMISSION_VALUES.each do |key|
      @hash[key] = (@cancellation_factor * @saleamount_factor * @hash[key][0].from_german_to_f).to_german_s
    end
    self
  end

  def combine_values(list_of_rows)
    @hash = combine_hashes(list_of_rows)
    last_value_wins
    last_real_value_wins
    int_values
    float_values
    number_of_commissions
    commissions_values
    @hash
  end
end