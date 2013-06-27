Ransack.configure do |config|
  # config.add_predicate 'range_name_is', # Name your predicate
  #                      # What non-compound ARel predicate will it use? (eq, matches, etc)
  #                      :arel_predicate => :in,
  #                      # Format incoming values as you see fit. (Default: Don't do formatting)
  #                      :formatter => proc {|range_name| Range.new(2, 8)},
  #                      # Validate a value. An "invalid" value won't be used in a search.
  #                      # Below is default.
  #                      :validator => proc {|v| v.present?},
  #                      # Should compounds be created? Will use the compound (any/all) version
  #                      # of the arel_predicate to create a corresponding any/all version of
  #                      # your predicate. (Default: true)
  #                      :compounds => true,
  #                      # Force a specific column type for type-casting of supplied values.
  #                      # (Default: use type from DB column)
  #                      :type => :string
  
  config.add_predicate 'nullness', # Name your predicate
                         # What non-compound ARel predicate will it use? (eq, matches, etc)
                         :arel_predicate => 'eq',
                         # Format incoming values as you see fit. (Default: Don't do formatting)
                         :formatter => proc {|v| "#{v}-diddly"},
                         # Validate a value. An "invalid" value won't be used in a search.
                         # Below is default.
                         :validator => proc {|v| v.present?},
                         # Should compounds be created? Will use the compound (any/all) version
                         # of the arel_predicate to create a corresponding any/all version of
                         # your predicate. (Default: true)
                         :compounds => false,
                         # Force a specific column type for type-casting of supplied values.
                         # (Default: use type from DB column)
                         :type => :string
                         
   config.add_predicate 'before_today', # Name your predicate
                          # What non-compound ARel predicate will it use? (eq, matches, etc)
                          :arel_predicate => 'lt',
                          # Format incoming values as you see fit. (Default: Don't do formatting)
                          :formatter => proc {|v| v == "1" ? Time.now.to_s(:db) : (Time.now - 1000.years).to_s(:db)},
                          # Validate a value. An "invalid" value won't be used in a search.
                          # Below is default.
                          :validator => proc {|v| v.present?},
                          # Should compounds be created? Will use the compound (any/all) version
                          # of the arel_predicate to create a corresponding any/all version of
                          # your predicate. (Default: true)
                          :compounds => false,
                          # Force a specific column type for type-casting of supplied values.
                          # (Default: use type from DB column)
                          :type => :string
  
end