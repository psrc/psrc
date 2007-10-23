var RuledTable = Class.create({
  initialize: function(element_id) {
    var table = $(element_id).select('tr').each(this.setupRow, this)
  },
  
  onMouseOverRow: function(event) {
    this.addClassName('highlight');
  },
  
  onMouseOutRow: function(event) {
    this.removeClassName('highlight');
  },
  
  setupRow: function(row) {
    row.observe('mouseover', this.onMouseOverRow);
    row.observe('mouseout', this.onMouseOutRow);
    if (this.onRowSetup) this.onRowSetup(row);
  }
});
