module ContributionsHelper
    def lock_unlock_helper(batch_id)
        batch = Batch.find(batch_id.id)
        if batch.locked?
            link_to_remote((image_tag "locked_with_permission.gif", :size => "12x12", :border => 0, :title => "Unlock this batch"), :url => {:action => 'unlock_batch', :batch_id => batch_id},
                                                                     :confirm => "Are you sure you want to unlock this batch? You're bound to mess something up.")
        else
            link_to_remote((image_tag "unlocked.gif", :size => "12x12", :border => 0, :title => "Lock this batch"), :url => {:action => 'lock_batch', :batch_id => batch_id})
        end
    end
    
    def format_num_helper
        if @batch.contributions.length < @batch.contributions_num
			'red'
		elsif @batch.contributions.length > @batch.contributions_num
			'green'
		else
			'black'
		end
    end
    
    def format_count_helper
        if @batch.entered_so_far < @batch.count_total
			'red'
		elsif @batch.entered_so_far > @batch.count_total
			'green'
		else
			'black'
		end
    end
    
    
end
