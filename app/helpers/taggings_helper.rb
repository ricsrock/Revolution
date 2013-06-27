module TaggingsHelper
  
  def name_with_group(tagging)
    tagging.tag.tag_group.name + ': ' + tagging.tag.name
  end
end
