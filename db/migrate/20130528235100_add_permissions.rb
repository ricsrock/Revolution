class AddPermissions < ActiveRecord::Migration
  def change
    resources = %w[Contacts SmartGroups Groups Contributions Reports CheckinBackgrounds]
    actions = %w[create read update destroy]
    
    resources.each do |resource|
      actions.each do |action|
        p = Permission.new(resource_name: resource, ability_name: action, created_by: 'system')
        p.save
      end
    end
  end
end
