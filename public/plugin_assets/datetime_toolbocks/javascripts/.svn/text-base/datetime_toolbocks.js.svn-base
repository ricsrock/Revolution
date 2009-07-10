/////////////////////////////////////////////////////////////////////////////////////
//
// Datetime Toolbocks - Intuitive Date Input Selection
// http://datetime.toolbocks.com
//
// Created by: 
//      Nathaniel Brown - http://nshb.net
//      Email: nshb(at)inimit.com
//
// Inspired by: 
//      Simon Willison - http://simon.incutio.com
//
// Contributors:
//      Darrell Taylor <darrellt(at)gmail.com>
//
// License:
//      Modified GNU Lesser General Public License version 2.1
//
// Dependencies:
//      Prototype 1.5.0_rc1
//
// Bugs:
//      Please submit bug reports to http://dev.toolbocks.com
//
// Comments:
//      Any feedback or suggestions, please email nshb(at)inimit.com
//
// Donations:
//      If Datebocks has saved your life, or close to it, please send a donation
//      to donate(at)toolbocks.com
//
/////////////////////////////////////////////////////////////////////////////////////

Object.extend(Hash, {
  toString: function(hash) {
    var values = [];
    
    hash.each(function(pair) {
      var string = pair.key + ":";
      
      if (typeof(pair.value) == 'object') {
          string += pair.value.toSource();
      } else if (typeof(pair.value) == 'string') {
          string += '"' + pair.value + '"';
      } else if (typeof(pair.value) == 'number') {
          string += pair.value;
      } else if (typeof(pair.value) == 'boolean') {
          string += pair.value;
      } else if (typeof(pair.value) == 'function') {
          string += '""';
      } else {
          string += '""';
      }
      
      values.push(string);
    });
    
    return "{" + values.join(', ') + "}";
  }
});

////////////////////////////////////////////////////////////////////////////////
///// Datetime Toolbocks

var DatetimeToolbocks = Class.create();

DatetimeToolbocks.VERSION = '3.0.3';

DatetimeToolbocks.CalendarOptions = $H({
  align                   : 'Br'
});

DatetimeToolbocks.DefaultOptions = {
  /* Configuration Options ---------------------------------------------- */
  //  - iso
  //  - de
  //  - us
  //  - dd/mm/yyyy
  //  - dd-mm-yyyy
  //  - mm/dd/yyyy
  //  - mm.dd.yyyy
  //  - yyyy-mm-dd

  inputValue              : false,
  inputName               : 'DatetimeToolbocks',
  elementId               : 'DatetimeToolbocks',
  elementIdSuffixInput    : 'Input',
  elementIdSuffixMessage  : 'Msg',
  elementIdSuffixHelp     : 'Help',
  elementIdSuffixButton   : 'Button',
  elementIdSuffixFlat     : 'Flat',
  classNameError          : 'error',
  classNameSuccess        : 'success',
  calendarOptions         : $H(),
  autoRollOver            : true,
  format                  : 'iso'
};

DatetimeToolbocks.Collection = {
  _collection: [],
  
  add: function(object) {
    DatetimeToolbocks.Collection._collection.push(object);
  },
  
  find: function(element_id) {
    var found = false;
    
    this._collection.each(function(datetime_toolbocks) {
      datetime_toolbocks_element_id = datetime_toolbocks.options.elementId + datetime_toolbocks.options.elementIdSuffixInput;
      if (datetime_toolbocks_element_id == element_id) {
        found = datetime_toolbocks;
        throw $break;
      }
    });
    
    return found;
  }
};

DatetimeToolbocks.prototype = {
  _formatString: 'yyyy-mm-dd',
  
  initialize: function(options) {
    options.calendarOptions = Object.clone(Object.extend(Object.clone(DatetimeToolbocks.CalendarOptions), options.calendarOptions || {}));
    this.options = Object.clone(Object.extend(Object.clone(DatetimeToolbocks.DefaultOptions), $H(options) || {}));

    this.setDateType();

    this._configureOptions();
    this._createHtml();
    
    DatetimeToolbocks.Collection.add(this);
    
    this._attachEvents();
    this.setDefaultFormatMessage();
    
  },
  
  _configureOptions: function() {
    this.options.calendarOptions.inputField = this.options.elementId + this.options.elementIdSuffixInput;
    this.options.messageField = this.options.elementId + this.options.elementIdSuffixMessage;
    
    if (this.options.calendarOptions.flat) {
      // remove all default options that assume it's not flat
      
      // remove align
      this.options.calendarOptions.remove('align');
      
      // set show button to false
      this.options.showButton = false;
      
      // if the option is set to true, then calculate the element id for the flat calendar
      this.options.calendarOptions.flat = (this.options.calendarOptions.flat == true) ? (this.options.elementId + this.options.elementIdSuffixFlat) : this.options.calendarOptions.flat;
    }
    
    this.options.showHelp = (this.options.showHelp == true || this.options.showHelp == false) ? this.options.showHelp : true;
    this.options.showButton = (this.options.showButton == true || this.options.showButton == false) ? this.options.showButton : true;
    this.options.buildFlat = (this.options.buildFlat == true || this.options.buildFlat == false) ? this.options.buildFlat : false;
    
    if (this.options.showButton == true && !this.options.calendarOptions.flat) {
      this.options.calendarOptions.button = this.options.elementId + this.options.elementIdSuffixButton;
    }
    
    if (this.options.showHelp == true) {
      this.options.helpField = this.options.elementId + this.options.elementIdSuffixHelp;
    }
  },
  
  _createHtml: function() {
    // set the default options
    var html = '';
    
    if (this.options.buildFlat) {
      html += '<div class="DatetimeToolbocksFlat" id="' + this.options.calendarOptions.flat + '"></div>\n';
    }

    html += '<div class="DatetimeToolbocks">\n' +
            '  <ul>\n' + 
            '    <li class="DatetimeToolbocksInput"><input value="' + (this.options.inputValue ? this.options.inputValue : '') + '" id=' + this.options.calendarOptions.inputField + ' name="' + this.options.inputName + '" size="30" type="text" /></li>\n' +
            ((this.options.showButton) ? '    <li class="DatetimeToolbocksIcon"><img alt="Calendar" id=' + this.options.calendarOptions.button + ' src="/plugin_assets/datetime_toolbocks/images/icon-calendar.gif" style="cursor: pointer;" /></li>\n' : '') +
            ((this.options.showHelp) ? '    <li class="DatetimeToolbocksHelp"><img alt="Help" id=' + this.options.helpField + ' src="/plugin_assets/datetime_toolbocks/images/icon-help.gif" style="cursor: pointer" /></li>\n' : '') +
            '  </ul>\n' +
            '  <div class="DatetimeToolbocksMessage"><div id=' + this.options.messageField + '></div></div>\n' +
            '</div>\n';

    var container_id = this.options.elementId + 'Container';
     
    document.write('<div id="' + container_id + '"></div>');
    new Insertion.Bottom(container_id, html);

    if (this.options.calendarOptions.flat || this.options.showButton) {
      Calendar.setup(this.options.calendarOptions);
    }
  },
  
  _attachEvents: function() {
     // attach the events to the Datetime Toolbocks element
     var input_field = $(this.options.calendarOptions.inputField);
     
     input_field.onchange = function(event) {
        if (!event) { var event = window.event; }
        
        var element_id = (this && this.id) ? this.id : Event.element(event).id;
        var datetime_toolbocks = DatetimeToolbocks.Collection.find(element_id);
        if (!datetime_toolbocks) { return; }

        return datetime_toolbocks.magicDate();
     }
     
     input_field.onclick = function() {
        this.select();
     }
     
     input_field.onkeypress = function(event) {
        if (!event) { var event = window.event; }

        var element_id = (this && this.id) ? this.id : Event.element(event).id;
        
        var datetime_toolbocks = DatetimeToolbocks.Collection.find(element_id);
        if (!datetime_toolbocks) { return; }

        datetime_toolbocks.keyObserver(event, "parse");
        return datetime_toolbocks.keyObserver(event, "return");
     }
     
     // add the event for when a user clicks on the help icon
     if (this.options.showHelp) {
       $(this.options.helpField).onclick = function() {
        DatetimeToolbocks.windowOpenCenter('/datetime_toolbocks/help', 'DatetimeToolbocksHelp', 'width=500,height=430,autocenter=true');
       }
     }
  },
  
  getOptions: function(datetime_toolbocks_id) {
    if (DateBocks.Collection.find(datetime_toolbocks_id)) {
      return DateBocks.Collection.find(datetime_toolbocks_id).options;
    } else {
      return $H();
    }
    
  },
    
  /* Properties --------------------------------------------------------- */

  _monthNames: [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ],

  _weekdayNames: [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ],

  _dateParsePatterns: [
    // Today
    {   
      re: /^tod[\w]+$|^now$/i,
      handler: function(db, bits) {
        return new Date();
      } 
    },
    // Tomorrow
    {   
      re: /^tom/i,
      handler: function(db, bits) {
        var d = new Date(); 
        d.setDate(d.getDate() + 1); 
        return d;
      }
    },
    // Yesterday
    {   
      re: /^yes/i,
      handler: function(db, bits) {
        var d = new Date();
        d.setDate(d.getDate() - 1);
        return d;
      }
    },
    // 4th
    {   
      re: /^(\d{1,2})(st|nd|rd|th)?$/i, 
      handler: function(db, bits) {
        var d = new Date();
        var yyyy = d.getFullYear();
        var dd = parseInt(bits[1], 10);
        var mm = d.getMonth();

        if ( db.dateInRange( yyyy, mm, dd ) ) {
           return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // 4th Jan
    {   
      re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of\s)?(\w+)$/i, 
      handler: function(db, bits) {
        var d = new Date();
        var yyyy = d.getFullYear();
        var dd = parseInt(bits[1], 10);
        var mm = db.parseMonth(bits[2]);

        if ( db.dateInRange( yyyy, mm, dd ) ) {
           return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // 4th Jan 2003
    {   
      re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of )?(\w+),? (\d{4})$/i,
      handler: function(db, bits) {
        var d = new Date();
        d.setDate(parseInt(bits[1], 10));
        d.setMonth(db.parseMonth(bits[2]));
        d.setYear(bits[3]);
        return d;
      }
    },
    // Jan 4th
    {   
      re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?$/i, 
      handler: function(db, bits) {
        var d = new Date();
        var yyyy = d.getFullYear(); 
        var dd = parseInt(bits[2], 10);
        var mm = db.parseMonth(bits[1]);
        if ( db.dateInRange( yyyy, mm, dd ) ) {
          return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // Jan 4th 2003
    {   
      re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?,? (\d{4})$/i,
      handler: function(db, bits) {
        var yyyy = parseInt(bits[3], 10); 
        var dd = parseInt(bits[2], 10);
        var mm = db.parseMonth(bits[1]);

        if ( db.dateInRange( yyyy, mm, dd ) )
           return db.getDateObj(yyyy, mm, dd);

      }
    },
    // Next Week, Last Week, Next Month, Last Month, Next Year, Last Year
    {   
      re: /^((next|last)\s(week|month|year))$/i,
      handler: function(db, bits) {
        var objDate = new Date();
        
        var dd = objDate.getDate();
        var mm = objDate.getMonth();
        var yyyy = objDate.getFullYear();
        
        switch (bits[3]) {
          case 'week':
            var newDay = (bits[2] == 'next') ? (dd + 7) : (dd - 7);
            objDate.setDate(newDay);
            break;
          case 'month':
            var newMonth = (bits[2] == 'next') ? (mm + 1) : (mm - 1);
            objDate.setMonth(newMonth);
            break;
          case 'year':
            var newYear = (bits[2] == 'next') ? (yyyy + 1) : (yyyy - 1);
            objDate.setYear(newYear);
            break;
        }
          
        return objDate;
      }
    },
    // 2 years from now , 3 days ago
    {   
      re: /^(\d{1,2}|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty) (day|week|month|year)s? (from|ago)(\s(today|now))?$/i,
      handler: function(db, bits) {
        var objDate = new Date();
        var dd = objDate.getDate();
        var mm = objDate.getMonth();
        var yyyy = objDate.getFullYear();
        
        if(isNaN(bits[1])) {
          switch (bits[1]) {
            case 'one': bits[1] = 1; break;
            case 'two': bits[1] = 2; break;
            case 'three': bits[1] = 3; break;
            case 'four': bits[1] = 4; break;
            case 'five': bits[1] = 5; break;
            case 'six': bits[1] = 6; break;
            case 'seven': bits[1] = 7; break;
            case 'eight': bits[1] = 8; break;
            case 'nine': bits[1] = 9; break;
            case 'ten': bits[1] = 10; break;
            case 'eleven': bits[1] = 11; break;
            case 'twelve': bits[1] = 12; break;
            case 'thirteen': bits[1] = 13; break;
            case 'fourteen': bits[1] = 14; break;      
            case 'fifteen': bits[1] = 15; break;
            case 'sixteen': bits[1] = 16; break;
            case 'seventeen': bits[1] = 17; break;
            case 'eighteen': bits[1] = 18; break;
            case 'nineteen': bits[1] = 19; break;
            case 'twenty': bits[1] = 20; break;
          }
        }
        
        var number = parseInt(bits[1], 10);
        var period = bits[2];
        var direction = bits[3];

        switch (period) {
          case 'day':
            var newDay = (direction == 'ago') ? (dd - number) : (dd + number);
            objDate.setDate(newDay);
            break;
          case 'week':
            var newDay = (direction == 'ago') ? (dd - (number*7)) : (dd + (number*7));
            objDate.setDate(newDay);
            break;
          case 'month':
            var newMonth = (direction == 'ago') ? (mm - number) : (mm + number);
            objDate.setMonth(newMonth);
            break;
          case 'year':
            var newYear = (direction == 'ago') ? (yyyy - number) : (yyyy + number);
            objDate.setYear(newYear);
            break;
        }
          
        return objDate;
      }
    },
    // next tuesday
    // this mon, tue, wed, thu, fri, sat, sun
    // mon, tue, wed, thu, fri, sat, sun
    {   
      re: /^(next|this)?\s?(\w+)$/i,
      handler: function(db, bits) {
        var d = new Date();
        var day = d.getDay();
        var newDay = db.parseWeekday(bits[2]);
        var addDays = newDay - day;
        if (newDay <= day) {
            addDays += 7;
        }
        d.setDate(d.getDate() + addDays);
        return d;
      }
    },
    // last Tuesday
    {   
      re: /^last (\w+)$/i,
      handler: function(db, bits) {
        var d = new Date();
        var wd = d.getDay();
        var nwd = db.parseWeekday(bits[1]);

        // determine the number of days to subtract to get last weekday
        var addDays = (-1 * (wd + 7 - nwd)) % 7;

        // above calculate 0 if weekdays are the same so we have to change this to 7
        if (0 == addDays) {
          addDays = -7;
        }
        
        // adjust date and return
        d.setDate(d.getDate() + addDays);
        return d;
  
      }
    },
    // mm/dd/yyyy (American style)
    {   
      re: /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/,
      handler: function(db, bits) {
        
        // if config date type is set to another format, use that instead
        if (db.getFormat() == 'mm/dd/yyyy') {
          var mm = parseInt(bits[1], 10);
          var dd = parseInt(bits[2], 10);
        } else {
          var dd = parseInt(bits[1], 10);
          var mm = parseInt(bits[2], 10);
        }

        if ((mm - 1) > 12) {
            real_day = mm;
            real_month = dd;
            
            mm = real_month;
            dd = real_day;
        }
        
        mm -= 1;
        
        var yyyy = parseInt(bits[3], 10);
        
        if ( db.dateInRange( yyyy, mm, dd ) ) {
          return db.getDateObj(yyyy, mm, dd);
        }

      }
    },
    // mm/dd/yy (American style) short year
    {   
      re: /^(\d{1,2})\/(\d{1,2})\/(\d{1,2})$/,
      handler: function(db, bits) {
        
        var d = new Date();
        var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[3], 10);
        var dd = parseInt(bits[2], 10);
        var mm = parseInt(bits[1], 10) - 1;

        if ( db.dateInRange(yyyy, mm, dd) ) {
          return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // mm/dd (American style) omitted year
    {   
      re: /^(\d{1,2})\/(\d{1,2})$/,
      handler: function(db, bits) {
        var d = new Date();
        var yyyy = d.getFullYear();
        var dd = parseInt(bits[2], 10);
        var mm = parseInt(bits[1], 10) - 1;

        if ( db.dateInRange(yyyy, mm, dd) ) {
          return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // mm-dd-yyyy
    {   
      re: /^(\d{1,2})-(\d{1,2})-(\d{4})$/,
      handler: function(db, bits) {
        if (this.getFormat() == 'dd-mm-yyyy') {
          // if the config is set to use a different schema, then use that instead
          var yyyy = parseInt(bits[3], 10);
          var dd = parseInt(bits[1], 10);
          var mm = parseInt(bits[2], 10) - 1;
        } else {
          var yyyy = parseInt(bits[3], 10);
          var dd = parseInt(bits[2], 10);
          var mm = parseInt(bits[1], 10) - 1;
        }

        if ( db.dateInRange( yyyy, mm, dd ) ) {
           return db.getDateObj(yyyy, mm, dd);
        }

      }
    },
    // mm.dd.yyyy || dd.mm.yyyy
    {   
      re: /^(\d{1,2})\.(\d{1,2})\.(\d{4})$/,
      handler: function(db, bits) {
        var mm = parseInt(bits[1], 10);
        var dd = parseInt(bits[2], 10);
        
        if ((mm - 1) > 12) {
            real_day = mm;
            real_month = dd;
            
            mm = real_month;
            dd = real_day;
        }
        
        mm -= 1;
        var yyyy = parseInt(bits[3], 10);

        if ( db.dateInRange( yyyy, mm, dd ) ) {
          return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // yyyy-mm-dd (ISO style)
    {   
      re: /^(\d{4})-(\d{1,2})-(\d{1,2})$/,
      handler: function(db, bits) {
        var yyyy = parseInt(bits[1], 10);
        var dd = parseInt(bits[3], 10);
        var mm = parseInt(bits[2], 10) - 1;

        if ( db.dateInRange( yyyy, mm, dd ) ) {
          return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // yy-mm-dd (ISO style) short year
    {   
      re: /^(\d{1,2})-(\d{1,2})-(\d{1,2})$/,
      handler: function(db, bits) {
        var d = new Date();
        var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[1], 10);
        var dd = parseInt(bits[3], 10);
        var mm = parseInt(bits[2], 10) - 1;

        if ( db.dateInRange( yyyy, mm, dd ) ) {
          return db.getDateObj(yyyy, mm, dd);
        }
      }
    },
    // mm-dd (ISO style) omitted year
    {   
      re: /^(\d{1,2})-(\d{1,2})$/,
      handler: function(db, bits) {
        var d = new Date();
        var yyyy = d.getFullYear();
        var dd = parseInt(bits[2], 10);
        var mm = parseInt(bits[1], 10) - 1;

        if ( db.dateInRange( yyyy, mm, dd ) ) {
           return db.getDateObj(yyyy, mm, dd);
        }
      }
    }
  ],

  /* Methods ------------------------------------------------------------ */

  setDateType: function() {
    switch (this.options.format) {
      case 'mm/dd/yyyy':
      case 'us':
        this.options.calendarOptions.ifFormat = '%m/%d/%Y';
        this._formatString = 'mm/dd/yyyy';
        break;
      case 'mm.dd.yyyy':
      case 'de':
        this.options.calendarOptions.ifFormat = '%m.%d.%Y';
        this._formatString = 'mm.dd.yyyy';
        break;
      case 'dd/mm/yyyy':
        this.options.calendarOptions.ifFormat = '%d/%m/%Y';
        this._formatString = 'dd/mm/yyyy';
        break;
      case 'dd-mm-yyyy':
        this.options.calendarOptions.ifFormat = '%d-%m-%Y';
        this._formatString = 'dd-mm-yyyy';
        break;
      case 'yyyy-mm-dd':
      case 'iso':
      case 'default':
      default:
        this.options.calendarOptions.ifFormat = '%Y-%m-%d';
        this._formatString = 'yyyy-mm-dd';
        break;
    }

    this.options.calendarOptions.ifFormat = this.options.calendarOptions.ifFormat;
  },

  /* Takes a string, returns the index of the month matching that string,
     throws an error if 0 or more than 1 matches
  */
  parseMonth: function(month) {
    var matches = this._monthNames.findAll(function(item) { 
      return new RegExp("^" + month, "i").test(item);
    });
    if (matches.length == 0) {
      throw new Error("Invalid month string. Format: " + this.getFormat());
    }
    if (matches.length < 1) {
      throw new Error("Ambiguous month. Format: " + this.getFormat());
    }
    return this.monthNames.indexOf(matches[0]);
  },

  /* Same as parseMonth but for days of the week */
  parseWeekday: function(weekday) {
    var matches = this._weekdayNames.findAll(function(item) {
      return new RegExp("^" + weekday, "i").test(item);
    });
    if (matches.length == 0) {
      throw new Error("Invalid day string. Format: " + this.getFormat());
    }
    if (matches.length < 1) {
      throw new Error("Ambiguous weekday. Format: " + this.getFormat());
    }
    return this._weekdayNames.indexOf(matches[0]);
  },

  getFormat: function() {
    switch (this.options.format) {
      case 'de':
       format = 'mm.dd.yyyy'; break;
      case 'us':
       format = 'mm/dd/yyyy'; break;
      case 'iso':
       format = 'yyyy-mm-dd'; break;
      default:
       format = this.options.format; break;
    }

    return format;
  },

  /* Given a year, month, and day, perform sanity checks to make
     sure the date is sane.
  */
  dateInRange: function(yyyy, mm, dd) {
    // if month out of range
    if ( mm < 0 || mm > 11 )
      throw new Error('Invalid month value.  Valid months values are 1 to 12. Format: ' + this.getFormat());

    if (!this.options.autoRollOver) {
      // get last day in month
      var d = (11 == mm)
        ? new Date(yyyy + 1, 0, 0)
        : new Date(yyyy, mm + 1, 0);

      // if date out of range
      if ( dd < 1 || dd > d.getDate() ) {
        throw new Error('Invalid date value.  Valid date values for '
          + this._monthNames[mm]
          + ' are 1 to '
          + d.getDate().toString()
          + '. Format: ' + this.getFormat()
        );
      }
    }

    return true;
  },
  
  /* Get Date Object */
  
  getDateObj: function(yyyy, mm, dd) {
    var obj = new Date();

    obj.setDate(1);
    obj.setYear(yyyy);
    obj.setMonth(mm);
    obj.setDate(dd);
    
    return obj;
  },

  /* Take a string and run it through the dateParsePatterns.
     The first one that succeeds will return a Date object. */
  parseDateString: function(s) {
    var dateParsePatterns = this._dateParsePatterns;
    for (var i = 0; i < dateParsePatterns.length; i++) {
      var re      = dateParsePatterns[i].re;
      var handler = dateParsePatterns[i].handler;
      var bits    = re.exec(s);
      if (bits) {
        return handler(this, bits);
      }
    }
    throw new Error("Invalid date string. Format: " + this.getFormat());
  },

  /* Put an extra 0 in front of single digit integers. */
  zeroPad: function(integer) {
    if (integer < 10) {
      return '0' + integer;
    } else {
      return integer;
    }
  },

  /* Try to make sense of the date in id.value . */
  magicDate: function() {
    var input = $(this.options.calendarOptions.inputField);
    var messageSpan = $(this.options.messageField);

    try {
      var d = this.parseDateString(input.value);

      var day = this.zeroPad(d.getDate());
      var month = this.zeroPad(d.getMonth() + 1);
      var year = d.getFullYear();

      switch (this.options.format) {
        case 'dd/mm/yyyy':
          input.value = day + '/' + month + '/' + year;
          break;
        case 'dd-mm-yyyy':
          input.value = day + '-' + month + '-' + year;
          break;
        case 'mm/dd/yyyy':
        case 'us':
          input.value = month + '/' + day + '/' + year;
          break;
        case 'mm.dd.yyyy':
        case 'de':
          input.value = month + '.' + day + '.' + year;
          break;
        case 'default':
        case 'iso':
        case 'yyyy-mm-dd':
        default:
          input.value = year + '-' + month + '-' + day;
          break;
      }

      input.className = '';
      
      // Human readable date
      if (messageSpan) {
        messageSpan.innerHTML = d.toDateString();
        messageSpan.className = this.options.classNameSuccess;
      }
    } catch (e) {
      input.className = this.options.classNameError;
      
      if (messageSpan) {
        var message = e.message;
        // Fix for IE6 bug
        if (message.indexOf('is null or not an object') > -1) {
            message = 'Invalid date string';
        }
        messageSpan.innerHTML = message;
        messageSpan.className = this.options.classNameError;
      }
    }
  },
  
  /* Key listener to catch the enter and return event */
  keyObserver: function(event, action) {
    if (!event) { var event = window.event; }
    var keyCode = (event.keyCode) ? event.keyCode : ((event.which) ? event.which : event.charCode);
    
  	if (keyCode == 13 || keyCode == 10) {
  		switch(action) {
  		  case 'parse':
  		    this.magicDate();
  		    break;
  		  case 'return':
  		  case 'false':
  		  default:
  		    return false;
  		    break;
  		}
    }
  },
  
  setDefaultFormatMessage: function() {
    $(this.options.messageField).innerHTML = this._formatString;
  }
};

DatetimeToolbocks.windowProperties = function(params) {
    var oRegex = new RegExp('');
    oRegex.compile( "(?:^|,)([^=]+)=(\\d+|yes|no|auto)", 'gim' );
      
    var oProperties = new Object();
    var oPropertiesMatch;
      
    while( ( oPropertiesMatch = oRegex.exec( params ) ) != null )  {
        var sValue = oPropertiesMatch[2];
      
        if ( sValue == ( 'yes' || '1' ) ) {
        	oProperties[ oPropertiesMatch[1] ] = true;
        } else if ( (! isNaN( sValue ) && sValue != 0) || ('auto' == sValue ) ) {
        	oProperties[ oPropertiesMatch[1] ] = sValue;
        }
    }
    	
    return oProperties;
};
    
DatetimeToolbocks.windowOpenCenter = function(url, name, properties){
      try {
        var oProperties = DatetimeToolbocks.windowProperties(properties);
        
        //if( !oProperties['autocenter'] || oProperties['fullscreen'] ) {
        //  return window.open(window_url, window_name, window_properties);
        //}
        
        w = parseInt(oProperties['width']);
        h = parseInt(oProperties['height']);
        w = w > 0 ? w : 640;
        h = h > 0 ? h : 480;
        
        if (screen) {
          t = (screen.height - h) / 2;
          l = (screen.width - w) / 2;
        } else {
          t = 250;
          l = 250;
        }
        
        properties = (w>0?",width="+w:"") + (h>0?",height="+h:"") + (t>0?",top="+t:"") + (l>0?",left="+l:"") + "," + properties.replace(/,(width=\s*\d+\s*|height=\s*\d+\s*|top=\s*\d+\s*||left=\s*\d+\s*)/gi, "");
        return window.open(url, name, properties);
      } catch( e ) {};
};