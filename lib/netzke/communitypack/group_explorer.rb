module Netzke
  module Communitypack
    # A component based on XXX with the following features:
    # 
    class GroupExplorer < Netzke::Basepack::FormPanel
      js_property :prevent_header, true

      def js_config
        group_config = configuration[:group_config] ? configuration[:group_config] : {}
        item_config = configuration[:item_config] ? configuration[:item_config] : {}
        selected_ids = configuration[:selected_ids].call(the_record)
        groups = []
        configuration[:get_groups].call.each_with_index do |g, i|
          items = configuration[:get_members].call(g).collect { |c|
            {
              boxLabel: c.to_s, 
              name: "records", 
              input_value: c.id, 
              checked: selected_ids.include?(c.id),
              :field_label => "", 
              :xtype => 'checkbox'
            }.merge(item_config)
          }
          groups << {
            :xtype => 'checkboxgroup',
            :fieldLabel => g.to_s,
            :cls => (i % 2) == 0  ? 'x-check-group-alt' : '' ,
            :columns => 7,
            :items => items
          }.merge(group_config)
        end
        groups << { xtype: 'hidden', name: 'record_id', value: configuration[:record_id].to_i }
        super.merge(:items => groups)
      end

      # TO DO
      # figure out a way to make this work with the FormPanel model method
      def the_record
        find_record(configuration[:record_id])
      end

      def find_record(id)
        Kernel.const_get(configuration[:record_model]).find(id)
      end


      endpoint :netzke_submit do |params|
        netzke_submit(params)
      end

      def netzke_submit(params)
        data = ActiveSupport::JSON.decode(params[:data])
        selected_ids = data['records']
        selected_ids.delete(false)
        if configuration[:assign_selected].call(find_record(data['record_id']), selected_ids )
          {:set_result => true}
        else
          # flash eventual errors
          nu.errors.to_a.each do |msg|
            flash :error => msg
          end
          {:netzke_feedback => @flash, :apply_form_errors => build_form_errors(record)}
        end
      end

    end

  end
end

