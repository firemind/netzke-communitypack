module Netzke
  module Communitypack
    # A component based on Ext.chart.Chart
    # 
    # Used as base for Pie Charts, Bar Charts, etc.
    class PieChart < Chart

      def configuration
        sup = super
        sup.merge(
          :store => 'chartDataStore',
          :animate => true,
          :shadow => true,
          :insetPadding => 25,
          :theme => 'Base:gradients',
          :insetPadding => 25,
          :series => [
            {
              :type => 'pie',
              :field => 'dataField',
              :showInLegend => true,
              :highlight => {
                :segment => {
                  :margin => 20
                }
              },
              :label => {
                :field => 'categoryField',
                :display => "rotate",
                :contrast => true,
                :font => '12px "Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif'
              }
            }
          ]
        )
      end

    end
  end
end
