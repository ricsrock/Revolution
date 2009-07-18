class Time
    def end_of_day
        change(:hour => 23, :min => 59, :sec => 59)
    end

    def end_of_week
      days_to_sunday = self.wday!=0 ? 7-self.wday : 0
      (self + days_to_sunday.days).end_of_day
    end
end
