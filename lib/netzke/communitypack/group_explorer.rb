module Netzke
  module Communitypack
    # A component based on XXX with the following features:
    # 
    class GroupExplorer < Netzke::Basepack::FormPanel
      js_property :prevent_header, true

      def configuration
        group_config = {} if ! group_config
        item_config = {} if ! item_config
        groups = []
        grp = 0; records.each do |c|
          if get_relation.call(c).id != grp
            @mymodel_group = {
              :xtype => 'checkboxgroup',
              :fieldLabel => get_relation.call(c).to_s + " " + get_relation.call(c).activities.count.to_s,
              :cls => (grp % 2) == 0  ? 'x-check-group-alt' : '' ,
              :columns => 7,
              :items => []
            }.merge(group_config)
            groups << @mymodel_group
          end
          @mymodel_group[:items] << {
             boxLabel: c.to_s, 
             name: "records", 
             input_value: c.id, 
             :field_label => "", 
             :xtype => 'checkbox'
          }.merge(item_config)
          grp = get_relation.call(c).id
        end
        super.merge(:items => groups)
      end
    end
  end
end

