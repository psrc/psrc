var SiteMap = Class.create(RuledTable, {
  initialize: function($super, id, expanded) {
    $super(id);
    this.expandedRows = expanded
  },
  
  onRowSetup: function(row) {
    Event.observe(row, 'click', this.onMouseClickRow.bindAsEventListener(this));
  },
  
  onMouseClickRow: function(event) {
    var element = event.element();
    if (this.isExpander(element)) {
      var row = event.findElement('tr');
      if (this.hasChildren(row)) {
        this.toggleBranch(row, element);
      }
    }
  },
  
  hasChildren: function(row) {
    return !row.hasClassName('no-children');
  },
  
  isExpander: function(element) {
    return element.match('img.expander');
  },
  
  isExpanded: function(row) {
    return row.hasClassName('children-visible');
  },
  
  isRow: function(element) {
    return element.tagName && element.match('tr');
  },
  
  extractLevel: function(row) {
    if (/level-(\d+)/i.test(row.className))
      return RegExp.$1.toInteger();
  },
  
  extractPageId: function(row) {
    if (/page-(\d+)/i.test(row.id))
      return RegExp.$1.toInteger();
  },
  
  getExpanderImageForRow: function(row) {
    return row.down('img');
  },     
  
  saveExpandedCookie: function() {
    document.cookie = "expanded_rows=" + this.expandedRows.uniq().join(",") + "; path=/admin";
  }, 
  
  hideBranch: function(row, img) {
    var level = this.extractLevel(row);
    var sibling = row.next();
    while (sibling != null) {
      if (this.isRow(sibling)) {
        if (this.extractLevel(sibling) <= level) break;
        sibling.hide();
      }
      sibling = sibling.next();
    }
    var pageId = this.extractPageId(row);
    this.expandedRows = this.expandedRows.reject(function(row) { return row == pageId });
    this.saveExpandedCookie();
    if (img == null) img = this.getExpanderImageForRow(row);
    img.src = img.src.replace(/collapse/, 'expand');
    row.removeClassName('children-visible');
    row.addClassName('children-hidden');
  },
  
  showBranchInternal: function(row, img) {
    var level = this.extractLevel(row);
    var sibling = row.next();
    var children = false;
    var childOwningSiblings = [];        
    while (sibling != null) {
      if (this.isRow(sibling)) {
        var siblingLevel = this.extractLevel(sibling);
        if (siblingLevel <= level) break;
        if (siblingLevel == level + 1) {
          sibling.show();
          if(sibling.hasClassName('children-visible')) {
            childOwningSiblings.push(sibling);
          } else {
            this.hideBranch(sibling);
          }
        }
        children = true;
      }
      sibling = sibling.next();
    }
    if (!children) this.getBranch(row);
    if (img == null) img = this.getExpanderImageForRow(row);          
    img.src = img.src.replace(/expand/, 'collapse');
    childOwningSiblings.each(function(sib) {
      this.showBranch(sib, null);            
    }, this);
    row.removeClassName('children-hidden');
    row.addClassName('children-visible');
  },
  
  showBranch: function(row, img) {
    this.showBranchInternal(row, img);
    this.expandedRows.push(this.extractPageId(row));
    this.saveExpandedCookie();
  },
  
  getBranch: function(row) {
    var level = this.extractLevel(row).toString();
    var id = this.extractPageId(row).toString();
    new Ajax.Updater(
      row,
      '../admin/ui/pages/children/' + id + '/' + level,
      {
        asynchronous: true,
        insertion: "after",
        onLoading: function(request) {
          $('busy-' + id).show();
          this.updating = true;
        }.bind(this),
        onComplete: function(request) {
          var sibling = row.next();
          while (sibling != null) {
            if (this.isRow(sibling)) {
              var siblingLevel = this.extractLevel(sibling);
              if (siblingLevel <= level) break;
              this.setupRow(sibling);
            }
            sibling = sibling.nextSibling;
          }
          this.updating = false;
          $('busy-' + id).fade();
        }.bind(this)
      }
    );
  },
  
  toggleBranch: function(row, img) {
    if (!this.updating) {
      if (this.isExpanded(row)) {
        this.hideBranch(row, img);
      } else {
        this.showBranch(row, img);
      }
    }
  }
});
