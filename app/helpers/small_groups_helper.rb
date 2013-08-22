module SmallGroupsHelper
  def meets(small_group)
    result = ''
    if small_group.cadence.present?
      cadence = small_group.cadence.name
    else
      cadence = 'TDB'
    end
    result << cadence
    if small_group.meets_ons.present?
      meets_on = small_group.meets_ons.collect {|m| m.weekday.name}.to_sentence
    else
      meets_on = 'TBD'
    end
    result << ' on ' + meets_on
    if small_group.meets_ats.present?
      meets_ats = small_group.meets_ats.collect {|a| a.meeting_time.time.to_s(:time)}.to_sentence
    else
      meets_ats = 'TBD'
    end
    result << ' at ' + meets_ats
    result
  end
end
