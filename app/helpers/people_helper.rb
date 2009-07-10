module PeopleHelper
    
  def note_text(note,user)
    if user.authorized_for_note?(note)
      note.text
    else
      "Sorry, this note is confidential."
    end
  end
    
end
