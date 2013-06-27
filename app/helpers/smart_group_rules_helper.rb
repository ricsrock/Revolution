module SmartGroupRulesHelper
  def smart_group_rule_renderer(builder)
    debug(builder.association(:smart_group_property))
  end
  
  def to_sentence(rule)
    result = ''
    case rule.smart_group_property.short
    when "group_count" && "first_group_attend" #group_id in 'extra'
      result << rule.smart_group_property.prose + ' '
      result << Group.find(rule.content.split('!')[1]).name + ' '
      result << rule.operator.prose + ' '
      result << rule.content.split('!')[0].to_s
    when "household_position" #content is an 'or' array
      result << rule.smart_group_property.prose + ' '
      result << rule.operator.prose + ' ' if rule.operator
      result << rule.content.split(',').to_sentence(last_word_connector: ' or ', two_words_connector: ' or ')
    else
      result << rule.smart_group_property.prose + ' '
      result << rule.operator.prose + ' ' if rule.operator
      result << rule.content
    end
    result
  end
  
end
