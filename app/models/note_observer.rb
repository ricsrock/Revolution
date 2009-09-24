class NoteObserver < ActiveRecord::Observer


  def after_create(note)
    #begin
      if note.noteable_type == "Relationship"
        if note.noteable.relationship_type.auto_notify?
          options = {}
          options[:created_by] = note.created_by
          options[:relationship_id] = note.noteable_id #find the relationship in the email worker... to get who's who in the relationship
          options[:sender_email] = User.find_by_login(note.created_by).email
          options[:note_text] = note.text
          EmailWorker.asynch_do_note_notify(options)
        end
      end
   #rescue
   #end
  end
  
end