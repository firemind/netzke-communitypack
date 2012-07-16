module Netzke
  module Communitypack
    # A component based on Ext.chart.Chart
    # 
    # Implementation of Ext JS Pie Charts http://dev.sencha.com/deploy/ext-4.1.0-gpl/examples/charts/Pie.html
    # For configuration see Netzke::Comunitypack::Chart
    class PieChart < Chart

      def configuration
        sup = super.clone
        series = [
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
              :font => '16px "Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif'
            }
          }
        ]
        series[0].deep_merge!(sup[:series][0] || {})
        sup.delete(:series) if sup[:series]
        {
          :store => 'chartDataStore',
          :animate => true,
          :shadow => true,
          :insetPadding => 25,
          :theme => 'Base:gradients',
          :insetPadding => 25,
          :series => series
        }.deep_merge(sup)
      end

    end
  end
end
