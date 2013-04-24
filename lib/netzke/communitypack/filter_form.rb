module Netzke
  module Communitypack
    # FormPanel containing fields which are mapped to lambda filter functions
    #     Adds a component_session[:filtered_ids] to parent component which can be used as scope
    #    
    #     Defines class method filter to add filter lambda functions. Example usage of this is:
    #         
    #       class CompanyFilter < Netzke::Communitypack::FilterForm 
    #         filter :my_filter, lambda { |filter_values|
    #    	     return Company.where(["company_type_id in (?)", filter_values[:company_types]]) 
    #    	   }
    #       end
    class FilterForm < Netzke::Basepack::FormPanel
      class_attribute :filters

      # override to save the parent component as instance veriable
      def initialize(a,parent)
        @filter_panel = parent
        super(a,parent)
      end

      js_method :on_apply, <<-JS
    function(){
      this.applyFilters({filter_values: this.getValues()});
      this.fireEvent("filter_applied");
    }
      JS

      # iterate over and call all filter functions and save the resulting ids in the
      # parent component's component_session[:filtered_ids]
      endpoint :apply_filters do |params|
        self.class.filters.each { |name,filter|
          if @ids
            @ids = @ids & filter.call(params[:filter_values]).collect{ |r| r.id }
          else
            @ids = filter.call(params[:filter_values]).collect{ |r| r.id }
          end
        }
        @filter_panel.component_session[:filtered_ids] = @ids
        {:set_result => "success" }
      end

      endpoint :clear_filters do |params|
        @filter_panel.component_session.clear
      end


      js_method :init_component, <<-JS
    function(){
      this.callParent();
      this.clearFilters();
      this.on('afterrender', function(){
  p = this.getParentNetzkeComponent();
  this.on('filter_applied', function(){
    this.getStore().load();
  }, p.getChildNetzkeComponent(this.toFilter));
      }, this);  
    }
      JS

      def self.filter(name, filter_func)
        current_filters = self.filters || {}
        current_filters.merge!(name => filter_func)
        self.filters= current_filters
      end 

    end
  end
end
