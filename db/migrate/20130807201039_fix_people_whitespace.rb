class FixPeopleWhitespace < ActiveRecord::Migration
  def change
    Person.all.each do |p|
      if p.first_name.starts_with?(' ')
        pp "===== person id #{p.id} first_name has whitespace. Fixing now. ====="
        p.update_attribute(:first_name, p.first_name.strip)
      end
      if p.last_name.starts_with?(' ')
        pp "===== person id #{p.id} last_name_name has whitespace. Fixing now. =====" 
        p.update_attribute(:last_name, p.last_name.strip)
      end
    end
  end
end
