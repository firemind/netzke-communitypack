module Netzke
  module Communitypack
    # A component based on Ext.chart.Chart
    # 
    # Used as base for Pie Charts, Bar Charts, etc.
    #
    # Accepts the following config options:
    # * chart_data - lambda function expected to return 2-dimensional array containing chart data. e.g. [['label 1', 5],['label 2', 42]]
    class Chart < Base
      js_base_class "Ext.chart.Chart"

      endpoint :load_store do |params|
        res = configuration[:chart_data].call
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
        this.callParent();
        this.updateChart();
      }
      JS

    end
  end
end

