module Netzke
  module Communitypack
    # A component based on XXX with the following features:
    # 
    class GroupExplorer < Netzke::Basepack::FormPanel
      js_property :prevent_header, true

      def js_config
        group_config = configuration[:group_config] ? configuration[:group_config] : {}
        item_config = configuration[:item_config] ? configuration[:item_config] : {}
        groups = []
        grp = 0; configuration[:get_records].call.each do |c|
          if configuration[:get_relation].call(c).id != grp
            @mymodel_group = {
              :xtype => 'checkboxgroup',
              :fieldLabel => configuration[:get_relation].call(c).to_s + " " + configuration[:get_relation].call(c).activities.count.to_s,
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
          grp = configuration[:get_relation].call(c).id
        end
        super.merge(:items => groups)
      end
    end
  end
end

