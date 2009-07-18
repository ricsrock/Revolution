class Array
   def to_hash_keys(&block)
     Hash[*self.collect { |v|
       [v, block.call(v)]
     }.flatten]
   end

   def to_hash_values(&block)
     Hash[*self.collect { |v|
       [block.call(v), v]
     }.flatten]
   end

   def extract_options!
     last.is_a?(::Hash) ? pop : {}
   end
end
