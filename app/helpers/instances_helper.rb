module InstancesHelper
  def for_field(instance)
    ('instance_type' + '_' + instance.instance_type.id.to_s)
  end
end
