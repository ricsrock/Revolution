module ContributionsHelper
  def number_formatter(recorded, declared)
    if recorded == declared
      'green-text'
    else
      'red-text'
    end
  end
end
