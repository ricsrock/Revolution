
#require 'Rmagick'

class Picture < ActiveRecord::Base
    belongs_to :person
    
    has_attachment :content_type => :image,
                    :storage => :file_system,
                    :max_size => 500.kilobytes,
                    :resize_to => '384x256>' ,
                    :processor => "Rmagick" ,
                    :thumbnails => {
                        :large => '120x120>' ,
                        :medium => '84x84>' ,
                        :small => '48x48>' ,
                        :tiny => '18x18'}
                        
    validates_as_attachment
end
