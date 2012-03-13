module Netzke
  module Communitypack
    # Extensible.calendar.CalendarPanel-based component with the following features:
    #
    # * (TODO) Loading Time-based Records and display them in calendar
    #
    # == Instance configuration
    # The following config options are supported:
    # * +model+ - name of the ActiveRecord model that provides data to this CalendarPanel, e.g. "Event"
    # * +scope+ - specifies how the data should be filtered.
    #   When it's a symbol, it's used as a scope name.
    #   When it's a string, it's a SQL statement (passed directly to +where+).
    #   When it's a hash, it's a conditions hash (passed directly to +where+).
    #   When it's an array, it's expanded into an SQL statement with arguments (passed directly to +where+), e.g.:
    #
    #     :scope => ["id > ?", 100])
    #
    #   When it's a Proc, it's passed the model class, and is expected to return a ActiveRecord::Relation, e.g.:
    #
    #     :scope => { |rel| rel.where(:id.gt => 100).order(:created_at) }
    #
    # * (TODO) +load_inline_data+ - (defaults to true) load initial data into the grid right after its instantiation
    #
    # GridPanel implements the following actions:
    # * (TODO) +add+ - inline adding of a record
    # * (TODO) +del+ - deletion of records
    # * (TODO) +edit+ - inline editing of a record
    # * (TODO) +apply+ - applying inline changes
    class CalendarPanel < Netzke::Base

      include self::Services
      js_base_class "Extensible.calendar.CalendarPanel"

      js_include :extensible
      js_include :init
      js_mixin :calendar_panel
      css_include :extensible

      class_config_option :default_instance_config, {
        :load_inline_data       => true,
      }

      def configuration
        super.merge({
          title: 'Basic Calendar',
          model: "Rapport",
          width: 1200,
          height: 1000
        })
      end

      def js_config #:nodoc:
        res = super
        res.merge({
          :title => res[:title] || self.class.js_properties[:title] || data_class.name.pluralize,
          :model => config[:model], # the model name
          :inline_data => (get_data if config[:load_inline_data]) # inline data (loaded along with the grid panel)
        })
      end

    end
  end
end
