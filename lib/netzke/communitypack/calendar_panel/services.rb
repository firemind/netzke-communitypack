module Netzke
  module Communitypack
    class CalendarPanel < Netzke::Base
      module Services
        extend ActiveSupport::Concern
        include Netzke::Basepack::DataAccessor
        included do
          endpoint :get_data do |params|
            get_data(params)
          end
        end

        # Implementation for the "get_data" endpoint
        def get_data(*args)
          params = args.first || {} # params are optional!
          if !config[:prohibit_read]
            {}.tap do |res|
              #records = get_records(params)
              res[:data] = { 
                id: 1,
                title: "First Event",
                start: "2012-03-12 12:00:00",
                end: "2012-03-12 15:00:00"
            },{
                id: 2,
                title: "Second Event",
                start: "2012-03-15 08:00:00",
                end: "2012-03-15 11:30:00"
             }
              #res[:data] = records.map{|r| r.netzke_array(columns(:with_meta => true))}
            end
          else
            flash :error => "You don't have permissions to read data"
            { :netzke_feedback => @flash }
          end
        end

        protected

        # Returns an array of records.
        def get_records(params)

          # Restore params from component_session if requested
          if params[:with_last_params]
            params = component_session[:last_params]
          else
            # remember the last params
            component_session[:last_params] = params
          end

          params[:limit] = config[:rows_per_page] if config[:enable_pagination]
          params[:scope] = config[:scope] # note, params[:scope] becomes ActiveSupport::HashWithIndifferentAccess

          data_adapter.get_records(params, columns)
        end

      end
    end
  end
end
