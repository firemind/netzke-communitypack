module Netzke
  module Communitypack
    # A component based on XXX with the following features:
    # 
    class CheckboxSelector < Netzke::Basepack::FormPanel
      js_property :prevent_header, true

      def js_config
        item_config = configuration[:item_config] ? configuration[:item_config] : {}
        group_config = configuration[:group_config] ? configuration[:group_config] : {}
        selected_ids = configuration[:selected_ids].call(the_record)
        items = configuration[:get_members].call.collect { |m|
          {
            boxLabel: m.to_s, 
            name: "records", 
            input_value: m.id, 
            checked: selected_ids.include?(m.id),
            :field_label => "", 
            :xtype => 'checkbox'
          }.merge(item_config)
        }
        items << { xtype: 'hidden', name: 'record_id', value: configuration[:record_id].to_i }
        super.merge(:items => [{
          :xtype => 'checkboxgroup',
          :fieldLabel => "",
          :columns => 7,
          :items => items
        }.merge(group_config)]
                   )
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

      def self.on_action_config(component)
        return <<-JS
          function(e){
            var selModel = this.getSelectionModel();
            var recordId = selModel.selected.first().getId();
            this.loadNetzkeComponent({name: "#{component}",
              params: {record_id: recordId},
              callback: function(w){
                w.show();
                w.on('close', function(){
                  if (w.closeRes === "ok") {
                    this.store.load();
                  }
                }, this);
              }, scope: this});
          }
        JS
      end
      
      def self.transfer_record_id(component_name, params, components)
        components[component_name.to_sym][:items].first.merge!(:record_id => params[:record_id].to_i) if params[:name] == component_name.to_s 
      end

    end

  end
end

