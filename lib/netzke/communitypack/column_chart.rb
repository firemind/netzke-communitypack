module Netzke
  module Communitypack
    # A component based on Ext.chart.Chart
    # 
    # Used as base for Pie Charts, Bar Charts, etc.
    class ColumnChart < Chart

      def configuration
        sup = super
        sup.merge(
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
        )
      end

    end
  end
end
