module Netzke
  module Communitypack
    # A component based on Ext.chart.Chart
    # 
    # Used as base for Pie Charts, Bar Charts, etc.
    class Chart < Base
      js_base_class "Ext.chart.Chart"

      endpoint :load_store do |params|
        res = self.chart_data
        res = [] if ! res
        res.delete_if{|r| r[1] == 0 }
        {:set_result =>  res.to_json }
      end

      js_method :update_chart, <<-JS
      function() {
        this.loadStore({}, function(res){ 
          res = Ext.decode(res);
          if(res.length == 0){
            this.store.removeAll();
            this.store.loadData([]);
          }else{
            this.store.loadData(res);
          }
          //this.store.loadData([["Peter Bosshard",5],["Heinrich Fischer",3]]);
        });
      } 
      JS

      js_method :init_component, <<-JS
      function() {
        Ext.define('ChartData', {
            extend: 'Ext.data.Model',
            fields: [ 
                {name: 'categoryField', type: 'string'},
                {name: 'dataField',  type: 'float'}
            ]
        });

        this.store = new Ext.data.Store({
          model: 'ChartData'
        });
        this.updateChart();
        this.callParent();
      }
      JS

    end
  end
end

