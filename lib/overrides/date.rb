class Date
  def to_time(form = :local)
    ::Time.send("#{form}", year, month, day)
  end

  def qtr
    month = self.strftime('%m').to_i
    case month
    when (1..3)
      '1'
    when (4..6)
      '2'
    when (7..9)
      '3'
    when (10..12)
      '4'
    end
  end

  def year_qtr
    year = self.strftime('%Y')
    year + '-' + self.qtr
  end
end
