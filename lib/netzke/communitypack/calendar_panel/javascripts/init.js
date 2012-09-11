Ext.Loader.setConfig({
  enabled: true,
disableCaching: false,
paths: {
  "Extensible": "/extensible/src",
}
});
Ext.require([
    'Extensible.calendar.data.MemoryEventStore',
    'Extensible.calendar.data.MemoryCalendarStore',
    'Extensible.calendar.CalendarPanel',
]);
