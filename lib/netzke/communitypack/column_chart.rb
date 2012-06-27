module Netzke
  module Communitypack
    # A component based on Ext.chart.Chart
    # 
    # Implementation of Ext JS Bar Charts http://dev.sencha.com/deploy/ext-4.1.0-gpl/examples/charts/Bar.html
    # For configuration see Netzke::Comunitypack::Chart
    class ColumnChart < Chart

      def configuration
        {
          :store => 'chartDataStore',
          :animate => true,
          :axes => [{
          :type => 'Numeric',
          :position => 'left',
          :fields => ['dataField'],
          :title => false,
          :grid => true,
          :minimum => 1
        }, {
          :type => 'Category',
          :position => 'bottom',
          :fields => ['categoryField']
        }],
          :series => [{
          :type => 'column',
          :axis => 'bottom',
          :gutter => 80,
          :xField => 'categoryField',
          :yField => 'dataField'
        }]
        }.deep_merge(super)
      end

    end
  end
end
