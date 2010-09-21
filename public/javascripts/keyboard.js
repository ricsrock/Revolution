/* ********************************************************************
 **********************************************************************
 * HTML Virtual Keyboard Interface Script - v1.32
 *   Copyright (c) 2009 - GreyWyvern
 *
 *  - Licenced for free distribution under the BSDL
 *          http://www.opensource.org/licenses/bsd-license.php
 *
 * Add a script-driven keyboard interface to text fields, password
 * fields and textareas.
 *
 * See http://www.greywyvern.com/code/javascript/keyboard for examples
 * and usage instructions.
 *
 * Version 1.32 - December 31, 2009
 *   - Added keyboard position switch function
 *   - Added some CSS3 styles
 *   - Added Pashto keyboard layout
 *   - Added Macedonian keyboard layout
 *   - Added Ukrainian keyboard layout
 *
 *   See full changelog at:
 *     http://www.greywyvern.com/code/javascript/keyboard.changelog.txt
 *
 * Keyboard Credits
 *   - Ukrainian keyboard layout by Dmitry Nikitin
 *   - Macedonian keyboard layout by Damjan Dimitrioski
 *   - Pashto keyboard layout by Ahmad Wali Achakzai (qamosona.com)
 *   - Armenian Eastern and Western keyboard layouts by Hayastan Project (www.hayastan.co.uk)
 *   - Pinyin keyboard layout from a collaboration with Lou Winklemann
 *   - Kazakh keyboard layout by Alex Madyankin
 *   - Danish keyboard layout by Verner Kjærsgaard
 *   - Slovak keyboard layout by Daniel Lara (www.learningslovak.com)
 *   - Belarusian, Serbian Cyrillic and Serbian Latin keyboard layouts by Evgeniy Titov
 *   - Bulgarian Phonetic keyboard layout by Samuil Gospodinov
 *   - Swedish keyboard layout by Håkan Sandberg
 *   - Romanian keyboard layout by Aurel
 *   - Farsi (Persian) keyboard layout by Kaveh Bakhtiyari (www.bakhtiyari.com)
 *   - Burmese keyboard layout by Cetanapa
 *   - Slovenian keyboard layout by Miran Zeljko
 *   - Hungarian keyboard layout by Antal Sall 'Hiromacu'
 *   - Arabic keyboard layout by Srinivas Reddy
 *   - Italian and Spanish (Spain) keyboard layouts by dictionarist.com
 *   - Lithuanian and Russian keyboard layouts by Ramunas
 *   - German keyboard layout by QuHno
 *   - French keyboard layout by Hidden Evil
 *   - Polish Programmers layout by moose
 *   - Turkish keyboard layouts by offcu
 *   - Dutch and US Int'l keyboard layouts by jerone
 *
 */
var VKI_attach, VKI_close;
  function VKI_buildKeyboardInputs() {
    var self = this;

    this.VKI_version = "1.32";
    this.VKI_showVersion = false;
    this.VKI_target = this.VKI_visible = false;
    this.VKI_shift = this.VKI_shiftlock = true;
    this.VKI_altgr = this.VKI_altgrlock = false;
    this.VKI_switcher = false; // show the position switcher
    this.VKI_above = 0; // 0 = below the input, 1 = above
    this.VKI_dead = true;
    this.VKI_deadkeysOn = true;
    this.VKI_kt = "Numpad";  // Default keyboard layout
    this.VKI_clearPasswords = false;  // Clear password fields on focus
    this.VKI_imageURI = "keyboard.png";
    this.VKI_clickless = 0;  // 0 = disabled, > 0 = delay in ms
    this.VKI_keyCenter = 3;

    this.VKI_isIE = /*@cc_on!@*/false;
    this.VKI_isIE6 = /*@if(@_jscript_version == 5.6)!@end@*/false;
    this.VKI_isIElt8 = /*@if(@_jscript_version < 5.8)!@end@*/false;
    this.VKI_isMoz = (navigator.product == "Gecko");
    this.VKI_isWebKit = RegExp("KHTML").test(navigator.userAgent);


    /* ***** Create keyboards ************************************** */
    this.VKI_layout = {};

    // - Lay out each keyboard in rows of sub-arrays.  Each sub-array
    //   represents one key.
    //
    // - Each sub-array consists of four slots described as follows:
    //     example: ["a", "A", "\u00e1", "\u00c1"]
    //
    //          a) Normal character
    //          A) Character + Shift/Caps
    //     \u00e1) Character + Alt/AltGr/AltLk
    //     \u00c1) Character + Shift/Caps + Alt/AltGr/AltLk
    //
    //   You may include sub-arrays which are fewer than four slots.
    //   In these cases, the missing slots will be blanked when the
    //   corresponding modifier key (Shift or AltGr) is pressed.
    //
    // - If the second slot of a sub-array matches one of the following
    //   strings:
    //     "Tab", "Caps", "Shift", "Enter", "Bksp",
    //     "Alt" OR "AltGr", "AltLk"
    //   then the function of the key will be the following,
    //   respectively:
    //     - Insert a tab
    //     - Toggle Caps Lock (technically a Shift Lock)
    //     - Next entered character will be the shifted character
    //     - Insert a newline (textarea), or close the keyboard
    //     - Delete the previous character
    //     - Next entered character will be the alternate character
    //     - Toggle Alt/AltGr Lock
    //
    //   The first slot of this sub-array will be the text to display
    //   on the corresponding key.  This allows for easy localisation
    //   of key names.
    //
    // - Layout dead keys (diacritic + letter) should be added as
    //   arrays of two item arrays with hash keys equal to the
    //   diacritic.  See the "this.VKI_deadkey" object below the layout
    //   definitions.  In  each two item child array, the second item
    //   is what the diacritic would change the first item to.
    //
    // - To disable dead keys for a layout, simply assign true to the
    //   DDK property of the layout (DDK = disable dead keys).  See the
    //   Numpad layout below for an example.
    //
    // - Note that any characters beyond the normal ASCII set should be
    //   entered in escaped Unicode format.  (eg \u00a3 = Pound symbol)
    //   You can find Unicode values for characters here:
    //     http://unicode.org/charts/
    //
    // - To remove a keyboard, just delete it, or comment it out of the
    //   source code


    this.VKI_layout.US = [ // US Standard Keyboard
      [["`", "~"], ["1", "!"], ["2", "@"], ["3", "#"], ["4", "$"], ["5", "%"], ["6", "^"], ["7", "&"], ["8", "*"], ["9", "("], ["0", ")"], ["-", "_"], ["=", "+"], ["Bksp", "Bksp"]],
      [["Tab", "Tab"], ["q", "Q"], ["w", "W"], ["e", "E"], ["r", "R"], ["t", "T"], ["y", "Y"], ["u", "U"], ["i", "I"], ["o", "O"], ["p", "P"], ["[", "{"], ["]", "}"], ["\\", "|"]],
      [["Caps", "Caps"], ["a", "A"], ["s", "S"], ["d", "D"], ["f", "F"], ["g", "G"], ["h", "H"], ["j", "J"], ["k", "K"], ["l", "L"], [";", ":"], ["'", '"'], ["Enter", "Enter"]],
      [["Shift", "Shift"], ["z", "Z"], ["x", "X"], ["c", "C"], ["v", "V"], ["b", "B"], ["n", "N"], ["m", "M"], [",", "<"], [".", ">"], ["/", "?"], ["Shift", "Shift"]]
    ];

    this.VKI_layout.Numpad = [ // Number pad
      [[""],[""],[""],["Bksp", "Bksp"]],
      [["7"], ["8"], ["9"],[""]],
      [["4"], ["5"], ["6"], [""]],
      [["1"], ["2"], ["3"],[""]],
	  [[""],["0"], [""],["Enter", "Enter"]]
    ];
    this.VKI_layout.Numpad.DDK = true;




    /* ***** Define Dead Keys ************************************** */
    this.VKI_deadkey = {};

    // - Lay out each dead key set in one row of sub-arrays.  The rows
    //   below are wrapped so uppercase letters are below their
    //   lowercase equivalents.
    //
    // - The first letter in each sub-array is the letter pressed after
    //   the diacritic.  The second letter is the letter this key-combo
    //   will generate.
    //
    // - Note that if you have created a new keyboard layout and want
    //   it included in the distributed script, PLEASE TELL ME if you
    //   have added additional dead keys to the ones below.

    this.VKI_deadkey['"'] = this.VKI_deadkey['\u00a8'] = [ // Umlaut / Diaeresis / Greek Dialytika
      ["a", "\u00e4"], ["e", "\u00eb"], ["i", "\u00ef"], ["o", "\u00f6"], ["u", "\u00fc"], ["y", "\u00ff"], ["\u03b9", "\u03ca"], ["\u03c5", "\u03cb"], ["\u016B", "\u01D6"], ["\u00FA", "\u01D8"], ["\u01D4", "\u01DA"], ["\u00F9", "\u01DC"],
      ["A", "\u00c4"], ["E", "\u00cb"], ["I", "\u00cf"], ["O", "\u00d6"], ["U", "\u00dc"], ["Y", "\u0178"], ["\u0399", "\u03aa"], ["\u03a5", "\u03ab"], ["\u016A", "\u01D5"], ["\u00DA", "\u01D7"], ["\u01D3", "\u01D9"], ["\u00D9", "\u01DB"]
    ];
    this.VKI_deadkey['~'] = [ // Tilde / Stroke
      ["a", "\u00e3"], ["l", "\u0142"], ["n", "\u00f1"], ["o", "\u00f5"],
      ["A", "\u00c3"], ["L", "\u0141"], ["N", "\u00d1"], ["O", "\u00d5"]
    ];
    this.VKI_deadkey['^'] = [ // Circumflex
      ["a", "\u00e2"], ["e", "\u00ea"], ["i", "\u00ee"], ["o", "\u00f4"], ["u", "\u00fb"], ["w", "\u0175"], ["y", "\u0177"],
      ["A", "\u00c2"], ["E", "\u00ca"], ["I", "\u00ce"], ["O", "\u00d4"], ["U", "\u00db"], ["W", "\u0174"], ["Y", "\u0176"]
    ];
    this.VKI_deadkey['\u02c7'] = [ // Baltic caron
      ["c", "\u010D"], ["d", "\u010f"], ["e", "\u011b"], ["s", "\u0161"], ["l", "\u013e"], ["n", "\u0148"], ["r", "\u0159"], ["t", "\u0165"], ["u", "\u01d4"], ["z", "\u017E"], ["\u00fc", "\u01da"],
      ["C", "\u010C"], ["D", "\u010e"], ["E", "\u011a"], ["S", "\u0160"], ["L", "\u013d"], ["N", "\u0147"], ["R", "\u0158"], ["T", "\u0164"], ["U", "\u01d3"], ["Z", "\u017D"], ["\u00dc", "\u01d9"]
    ];
    this.VKI_deadkey['\u02d8'] = [ // Romanian and Turkish breve
      ["a", "\u0103"], ["g", "\u011f"],
      ["A", "\u0102"], ["G", "\u011e"]
    ];
    this.VKI_deadkey['-'] = this.VKI_deadkey['\u00af'] = [ // Macron
      ["a", "\u0101"], ["e", "\u0113"], ["i", "\u012b"], ["o", "\u014d"], ["u", "\u016B"], ["y", "\u0233"], ["\u00fc", "\u01d6"],
      ["A", "\u0100"], ["E", "\u0112"], ["I", "\u012a"], ["O", "\u014c"], ["U", "\u016A"], ["Y", "\u0232"], ["\u00dc", "\u01d5"]
    ];
    this.VKI_deadkey['`'] = [ // Grave
      ["a", "\u00e0"], ["e", "\u00e8"], ["i", "\u00ec"], ["o", "\u00f2"], ["u", "\u00f9"], ["\u00fc", "\u01dc"],
      ["A", "\u00c0"], ["E", "\u00c8"], ["I", "\u00cc"], ["O", "\u00d2"], ["U", "\u00d9"], ["\u00dc", "\u01db"]
    ];
    this.VKI_deadkey["'"] = this.VKI_deadkey['\u00b4'] = this.VKI_deadkey['\u0384'] = [ // Acute / Greek Tonos
      ["a", "\u00e1"], ["e", "\u00e9"], ["i", "\u00ed"], ["o", "\u00f3"], ["u", "\u00fa"], ["y", "\u00fd"], ["\u03b1", "\u03ac"], ["\u03b5", "\u03ad"], ["\u03b7", "\u03ae"], ["\u03b9", "\u03af"], ["\u03bf", "\u03cc"], ["\u03c5", "\u03cd"], ["\u03c9", "\u03ce"], ["\u00fc", "\u01d8"],
      ["A", "\u00c1"], ["E", "\u00c9"], ["I", "\u00cd"], ["O", "\u00d3"], ["U", "\u00da"], ["Y", "\u00dd"], ["\u0391", "\u0386"], ["\u0395", "\u0388"], ["\u0397", "\u0389"], ["\u0399", "\u038a"], ["\u039f", "\u038c"], ["\u03a5", "\u038e"], ["\u03a9", "\u038f"], ["\u00dc", "\u01d7"]
    ];
    this.VKI_deadkey['\u02dd'] = [ // Hungarian Double Acute Accent
      ["o", "\u0151"], ["u", "\u0171"],
      ["O", "\u0150"], ["U", "\u0170"]
    ];
    this.VKI_deadkey['\u0385'] = [ // Greek Dialytika + Tonos
      ["\u03b9", "\u0390"], ["\u03c5", "\u03b0"]
    ];
    this.VKI_deadkey['\u00b0'] = this.VKI_deadkey['\u00ba'] = [ // Ring
      ["a", "\u00e5"], ["u", "\u016f"],
      ["A", "\u00c5"], ["U", "\u016e"]
    ];
    this.VKI_deadkey['\u02DB'] = [ // Ogonek
      ["a", "\u0106"], ["e", "\u0119"], ["i", "\u012f"], ["o", "\u01eb"], ["u", "\u0173"], ["y", "\u0177"],
      ["A", "\u0105"], ["E", "\u0118"], ["I", "\u012e"], ["O", "\u01ea"], ["U", "\u0172"], ["Y", "\u0176"]
    ];
    this.VKI_deadkey['\u02D9'] = [ // Dot-above
      ["c", "\u010B"], ["e", "\u0117"], ["g", "\u0121"], ["z", "\u017C"],
      ["C", "\u010A"], ["E", "\u0116"], ["G", "\u0120"], ["Z", "\u017B"]
    ];
    this.VKI_deadkey['\u00B8'] = this.VKI_deadkey['\u201a'] = [ // Cedilla
      ["c", "\u00e7"], ["s", "\u015F"],
      ["C", "\u00c7"], ["S", "\u015E"]
    ];
    this.VKI_deadkey[','] = [ // Comma
      ["s", (this.VKI_isIElt8) ? "\u015F" : "\u0219"], ["t", (this.VKI_isIElt8) ? "\u0163" : "\u021B"],
      ["S", (this.VKI_isIElt8) ? "\u015E" : "\u0218"], ["T", (this.VKI_isIElt8) ? "\u0162" : "\u021A"]
    ];


    /* ***** Define Symbols **************************************** */
    this.VKI_symbol = {
      '\u200c': "ZW\r\nNJ", '\u200d': "ZW\r\nJ"
    };



    /* ****************************************************************
     * Attach the keyboard to an element
     *
     */
    this.VKI_attachKeyboard = VKI_attach = function(elem) {
      if (elem.VKI_attached) return false;
      var keybut = document.createElement('img');
          keybut.src = this.VKI_imageURI;
          keybut.alt = "Keyboard interface";
          keybut.className = "keyboardInputInitiator";
          keybut.title = "Display graphical keyboard interface";
          keybut.elem = elem;
          keybut.onclick = function() { self.VKI_show(this.elem); };
      elem.VKI_attached = true;
      elem.parentNode.insertBefore(keybut, (elem.dir == "rtl") ? elem : elem.nextSibling);
      if (this.VKI_isIE) {
        elem.onclick = elem.onselect = elem.onkeyup = function(e) {
          if ((e || event).type != "keyup" || !this.readOnly)
            this.range = document.selection.createRange();
        };
      }
    };


    /* ***** Find tagged input & textarea elements ***************** */
    var inputElems = [
      document.getElementsByTagName('input'),
      document.getElementsByTagName('textarea')
    ];
    for (var x = 0, elem; elem = inputElems[x++];)
      for (var y = 0, ex; ex = elem[y++];)
        if ((ex.nodeName == "TEXTAREA" || ex.type == "text" || ex.type == "password") && ex.className.indexOf("keyboardInput") > -1)
          this.VKI_attachKeyboard(ex);


    /* ***** Build the keyboard interface ************************** */
    this.VKI_keyboard = document.createElement('table');
    this.VKI_keyboard.id = "keyboardInputMaster";
    this.VKI_keyboard.dir = "ltr";
    this.VKI_keyboard.cellSpacing = this.VKI_keyboard.border = "0";

    var thead = document.createElement('thead');
      var tr = document.createElement('tr');
        var th = document.createElement('th');


            var label = document.createElement('label');
            th.appendChild(label);
          tr.appendChild(th);

        var td = document.createElement('td');
          if (this.VKI_switcher) {
            var switcher = document.createElement('span');
                switcher.id = "keyboardInputSwitch";
                switcher.appendChild(document.createTextNode("\u21d1"));
                switcher.title = "Switch keyboard position";
                switcher.onmousedown = function() { this.className = "pressed"; };
                switcher.onmouseup = function() { this.className = ""; };
                switcher.onclick = function() {
                  self.VKI_position(self.VKI_above ^= 1);
                  this.firstChild.nodeValue = (self.VKI_above) ? "\u21d3" : "\u21d1";
                  return false;
                };
              td.appendChild(switcher);
          }

          var clearer = document.createElement('span');
              clearer.id = "keyboardInputClear";
              clearer.appendChild(document.createTextNode("Clear"));
              clearer.title = "Clear this input";
              clearer.onmousedown = function() { this.className = "pressed"; };
              clearer.onmouseup = function() { this.className = ""; };
              clearer.onclick = function() {
                self.VKI_target.value = "";
                self.VKI_target.focus();
                return false;
              };
            td.appendChild(clearer);


          tr.appendChild(td);
        thead.appendChild(tr);
    this.VKI_keyboard.appendChild(thead);

    var tbody = document.createElement('tbody');
      var tr = document.createElement('tr');
        var td = document.createElement('td');
            td.colSpan = "2";
          var div = document.createElement('div');
              div.id = "keyboardInputLayout";
            td.appendChild(div);
          if (this.VKI_showVersion) {
            var div = document.createElement('div');
              var ver = document.createElement('var');
                  ver.appendChild(document.createTextNode("v" + this.VKI_version));
                div.appendChild(ver);
              td.appendChild(div);
          }
          tr.appendChild(td);
        tbody.appendChild(tr);
    this.VKI_keyboard.appendChild(tbody);

    if (this.VKI_isIE6) {
      this.VKI_iframe = document.createElement('iframe');
      this.VKI_iframe.style.position = "absolute";
      this.VKI_iframe.style.border = "0px none";
      this.VKI_iframe.style.filter = "mask()";
      this.VKI_iframe.style.zIndex = "999999";
      this.VKI_iframe.src = this.VKI_imageURI;
    }


    /* ****************************************************************
     * Build or rebuild the keyboard keys
     *
     */
    this.VKI_buildKeys = function() {
      this.VKI_shift = this.VKI_shiftlock = this.VKI_altgr = this.VKI_altgrlock = this.VKI_dead = false;
     /* this.VKI_deadkeysOn = (this.VKI_layout[this.VKI_kt].DDK) ? false : this.VKI_keyboard.getElementsByTagName('label')[0].getElementsByTagName('input')[0].checked; */

      var container = this.VKI_keyboard.tBodies[0].getElementsByTagName('div')[0];
      while (container.firstChild) container.removeChild(container.firstChild);

      for (var x = 0, hasDeadKey = false, lyt; lyt = this.VKI_layout[this.VKI_kt][x++];) {
        var table = document.createElement('table');
            table.cellSpacing = table.border = "0";
        if (lyt.length <= this.VKI_keyCenter) table.className = "keyboardInputCenter";
          var tbody = document.createElement('tbody');
            var tr = document.createElement('tr');
            for (var y = 0, lkey; lkey = lyt[y++];) {
              var td = document.createElement('td');
                if (this.VKI_symbol[lkey[0]]) {
                  var span = document.createElement('span');
                      span.className = lkey[0];
                      span.appendChild(document.createTextNode(this.VKI_symbol[lkey[0]]));
                    td.appendChild(span);
                } else td.appendChild(document.createTextNode(lkey[0] || "\xa0"));

                var className = [];
                if (this.VKI_deadkeysOn)
                  for (key in this.VKI_deadkey)
                    if (key === lkey[0]) { className.push("alive"); break; }
                if (lyt.length > this.VKI_keyCenter && y == lyt.length) className.push("last");
                if (lkey[0] == " ") className.push("space");
                  td.className = className.join(" ");

                  td.VKI_clickless = 0;
                  if (!td.click) {
                    td.click = function() {
                      var evt = this.ownerDocument.createEvent('MouseEvents');
                      evt.initMouseEvent('click', true, true, this.ownerDocument.defaultView, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
                      this.dispatchEvent(evt);
                    };
                  }
                  td.onmouseover = function() {
                    if (self.VKI_clickless) {
                      var _self = this;
                      clearTimeout(this.VKI_clickless);
                      this.VKI_clickless = setTimeout(function() { _self.click(); }, self.VKI_clickless);
                    }
                    if ((this.firstChild.nodeValue || this.firstChild.className) != "\xa0") this.className += " hover";
                  };
                  td.onmouseout = function() {
                    if (self.VKI_clickless) clearTimeout(this.VKI_clickless);
                    this.className = this.className.replace(/ ?(hover|pressed)/g, "");
                  };
                  td.onmousedown = function() {
                    if (self.VKI_clickless) clearTimeout(this.VKI_clickless);
                    if ((this.firstChild.nodeValue || this.firstChild.className) != "\xa0") this.className += " pressed";
                  };
                  td.onmouseup = function() {
                    if (self.VKI_clickless) clearTimeout(this.VKI_clickless);
                    this.className = this.className.replace(/ ?pressed/g, "");
                  };
                  td.ondblclick = function() { return false; };

                switch (lkey[1]) {
                  case "Caps": case "Shift":
                  case "Alt": case "AltGr": case "AltLk":
                    td.onclick = (function(type) { return function() { self.VKI_modify(type); return false; }; })(lkey[1]);
                    break;
                  case "Tab":
                    td.onclick = function() { self.VKI_insert("\t"); return false; };
                    break;
                  case "Bksp":
                    td.onclick = function() {
                      self.VKI_target.focus();
                      if (self.VKI_target.setSelectionRange) {
                        if (self.VKI_target.readOnly && self.VKI_isWebKit) {
                          var rng = [self.VKI_target.selStart || 0, self.VKI_target.selEnd || 0];
                        } else var rng = [self.VKI_target.selectionStart, self.VKI_target.selectionEnd];
                        if (rng[0] < rng[1]) rng[0]++;
                        self.VKI_target.value = self.VKI_target.value.substr(0, rng[0] - 1) + self.VKI_target.value.substr(rng[1]);
                        self.VKI_target.setSelectionRange(rng[0] - 1, rng[0] - 1);
                        if (self.VKI_target.readOnly && self.VKI_isWebKit) {
                          var range = window.getSelection().getRangeAt(0);
                          self.VKI_target.selStart = range.startOffset;
                          self.VKI_target.selEnd = range.endOffset;
                        }
                      } else if (self.VKI_target.createTextRange) {
                        try {
                          self.VKI_target.range.select();
                        } catch(e) { self.VKI_target.range = document.selection.createRange(); }
                        if (!self.VKI_target.range.text.length) self.VKI_target.range.moveStart('character', -1);
                        self.VKI_target.range.text = "";
                      } else self.VKI_target.value = self.VKI_target.value.substr(0, self.VKI_target.value.length - 1);
                      if (self.VKI_shift) self.VKI_modify("Shift");
                      if (self.VKI_altgr) self.VKI_modify("AltGr");
                      self.VKI_target.focus();
                      return true;
                    };
                    break;
                  case "Enter":
                    td.onclick = function() {
                      if (self.VKI_target.nodeName != "TEXTAREA") {
                        self.VKI_close();
                        this.className = this.className.replace(/ ?(hover|pressed)/g, "");
                      } else self.VKI_insert("\n");
                      return true;
                    };
                    break;
                  default:
                    td.onclick = function() {
                      var character = this.firstChild.nodeValue || this.firstChild.className;
                      if (self.VKI_deadkeysOn && self.VKI_dead) {
                        if (self.VKI_dead != character) {
                          for (key in self.VKI_deadkey) {
                            if (key == self.VKI_dead) {
                              if (character != " ") {
                                for (var z = 0, rezzed = false, dk; dk = self.VKI_deadkey[key][z++];) {
                                  if (dk[0] == character) {
                                    self.VKI_insert(dk[1]);
                                    rezzed = true;
                                    break;
                                  }
                                }
                              } else {
                                self.VKI_insert(self.VKI_dead);
                                rezzed = true;
                              } break;
                            }
                          }
                        } else rezzed = true;
                      } self.VKI_dead = false;

                      if (!rezzed && character != "\xa0") {
                        if (self.VKI_deadkeysOn) {
                          for (key in self.VKI_deadkey) {
                            if (key == character) {
                              self.VKI_dead = key;
                              this.className += " dead";
                              if (self.VKI_shift) self.VKI_modify("Shift");
                              if (self.VKI_altgr) self.VKI_modify("AltGr");
                              break;
                            }
                          }
                          if (!self.VKI_dead) self.VKI_insert(character);
                        } else self.VKI_insert(character);
                      }

                      self.VKI_modify("");
                      return false;
                    };

                }
                tr.appendChild(td);
              tbody.appendChild(tr);
            table.appendChild(tbody);

            for (var z = 0; z < 4; z++)
              if (this.VKI_deadkey[lkey[z] = lkey[z] || "\xa0"]) hasDeadKey = true;
        }
        container.appendChild(table);
      }
      /*this.VKI_deadkeysElem.style.display = (!this.VKI_layout[this.VKI_kt].DDK && hasDeadKey) ? "inline" : "none"; */
    };

    this.VKI_buildKeys();
    VKI_disableSelection(this.VKI_keyboard);


    /* ****************************************************************
     * Controls modifier keys
     *
     */
    this.VKI_modify = function(type) {
      switch (type) {
        case "Alt":
        case "AltGr": this.VKI_altgr = !this.VKI_altgr; break;
        case "AltLk": this.VKI_altgrlock = !this.VKI_altgrlock; break;
        case "Caps": this.VKI_shiftlock = !this.VKI_shiftlock; break;
        case "Shift": this.VKI_shift = !this.VKI_shift; break;
      } var vchar = 0;
      if (!this.VKI_shift != !this.VKI_shiftlock) vchar += 1;
      if (!this.VKI_altgr != !this.VKI_altgrlock) vchar += 2;

      var tables = this.VKI_keyboard.getElementsByTagName('table');
      for (var x = 0; x < tables.length; x++) {
        var tds = tables[x].getElementsByTagName('td');
        for (var y = 0; y < tds.length; y++) {
          var className = [], lkey = this.VKI_layout[this.VKI_kt][x][y];

          if (tds[y].className.indexOf('hover') > -1) className.push("hover");

          switch (lkey[1]) {
            case "Alt":
            case "AltGr":
              if (this.VKI_altgr) className.push("dead");
              break;
            case "AltLk":
              if (this.VKI_altgrlock) className.push("dead");
              break;
            case "Shift":
              if (this.VKI_shift) className.push("dead");
              break;
            case "Caps":
              if (this.VKI_shiftlock) className.push("dead");
              break;
            case "Tab": case "Enter": case "Bksp": break;
            default:
              if (type) {
                tds[y].removeChild(tds[y].firstChild);
                if (this.VKI_symbol[lkey[vchar]]) {
                  var span = document.createElement('span');
                      span.className = lkey[vchar];
                      span.appendChild(document.createTextNode(this.VKI_symbol[lkey[vchar]]));
                    tds[y].appendChild(span);
                } else tds[y].appendChild(document.createTextNode(lkey[vchar]));
              }
              if (this.VKI_deadkeysOn) {
                var character = tds[y].firstChild.nodeValue || tds[y].firstChild.className;
                if (this.VKI_dead) {
                  if (character == this.VKI_dead) className.push("dead");
                  for (var z = 0; z < this.VKI_deadkey[this.VKI_dead].length; z++) {
                    if (character == this.VKI_deadkey[this.VKI_dead][z][0]) {
                      className.push("target");
                      break;
                    }
                  }
                }
                for (key in this.VKI_deadkey)
                  if (key === character) { className.push("alive"); break; }
              }
          }

          if (y == tds.length - 1 && tds.length > this.VKI_keyCenter) className.push("last");
          if (lkey[0] == " ") className.push("space");
          tds[y].className = className.join(" ");
        }
      }
    };


    /* ****************************************************************
     * Insert text at the cursor
     *
     */
    this.VKI_insert = function(text) {
      this.VKI_target.focus();
      if (this.VKI_target.maxLength) this.VKI_target.maxlength = this.VKI_target.maxLength;
      if (typeof this.VKI_target.maxlength == "undefined" ||
          this.VKI_target.maxlength < 0 ||
          this.VKI_target.value.length < this.VKI_target.maxlength) {
        if (this.VKI_target.setSelectionRange) {
          if (this.VKI_target.readOnly && this.VKI_isWebKit) {
            var rng = [this.VKI_target.selStart || 0, this.VKI_target.selEnd || 0];
          } else var rng = [this.VKI_target.selectionStart, this.VKI_target.selectionEnd];
          this.VKI_target.value = this.VKI_target.value.substr(0, rng[0]) + text + this.VKI_target.value.substr(rng[1]);
          if (text == "\n" && window.opera) rng[0]++;
          this.VKI_target.setSelectionRange(rng[0] + text.length, rng[0] + text.length);
          if (this.VKI_target.readOnly && this.VKI_isWebKit) {
            var range = window.getSelection().getRangeAt(0);
            this.VKI_target.selStart = range.startOffset;
            this.VKI_target.selEnd = range.endOffset;
          }
        } else if (this.VKI_target.createTextRange) {
          try {
            this.VKI_target.range.select();
          } catch(e) { this.VKI_target.range = document.selection.createRange(); }
          this.VKI_target.range.text = text;
          this.VKI_target.range.collapse(true);
          this.VKI_target.range.select();
        } else this.VKI_target.value += text;
        if (this.VKI_shift) this.VKI_modify("Shift");
        if (this.VKI_altgr) this.VKI_modify("AltGr");
        this.VKI_target.focus();
      } else if (this.VKI_target.createTextRange && this.VKI_target.range)
        this.VKI_target.range.select();
    };


    /* ****************************************************************
     * Show the keyboard interface
     *
     */
    this.VKI_show = function(elem) {
      if (this.VKI_target = elem) {
        if (this.VKI_visible != elem) {
          if (this.VKI_isIE) {
            if (!this.VKI_target.range) {
              this.VKI_target.range = this.VKI_target.createTextRange();
              this.VKI_target.range.moveStart('character', this.VKI_target.value.length);
            } this.VKI_target.range.select();
          }
          try { this.VKI_keyboard.parentNode.removeChild(this.VKI_keyboard); } catch (e) {}
          if (this.VKI_clearPasswords && this.VKI_target.type == "password") this.VKI_target.value = "";

          var elem = this.VKI_target;
          this.VKI_target.keyboardPosition = "absolute";
          do {
            if (VKI_getStyle(elem, "position") == "fixed") {
              this.VKI_target.keyboardPosition = "fixed";
              break;
            }
          } while (elem = elem.offsetParent);

          if (this.VKI_isIE6) document.body.appendChild(this.VKI_iframe);
          document.body.appendChild(this.VKI_keyboard);
          this.VKI_keyboard.style.top = this.VKI_keyboard.style.right = this.VKI_keyboard.style.bottom = this.VKI_keyboard.style.left = "auto";
          this.VKI_keyboard.style.position = this.VKI_target.keyboardPosition;

          this.VKI_visible = this.VKI_target;
          this.VKI_position();
          this.VKI_target.focus();
        } else this.VKI_close();
      }
    };


    /* ****************************************************************
     * Position the keyboard
     *
     */
    this.VKI_position = function(above) {
      if (typeof above == "undefined") above = self.VKI_above;
      if (self.VKI_visible) {
        var inputElemPos = VKI_findPos(self.VKI_target);
        above = (above) ? -self.VKI_keyboard.offsetHeight - 3 : self.VKI_target.offsetHeight + 3;
        self.VKI_keyboard.style.top = inputElemPos[1] - ((self.VKI_target.keyboardPosition == "fixed" && !self.VKI_isIE && !self.VKI_isMoz) ? VKI_scrollDist()[1] : 0) + above + "px";
        self.VKI_keyboard.style.left = Math.min(VKI_innerDimensions()[0] - self.VKI_keyboard.offsetWidth - 15, inputElemPos[0]) + "px";
        if (self.VKI_isIE6) {
          self.VKI_iframe.style.width = self.VKI_keyboard.offsetWidth + "px";
          self.VKI_iframe.style.height = self.VKI_keyboard.offsetHeight + "px";
          self.VKI_iframe.style.top = self.VKI_keyboard.style.top;
          self.VKI_iframe.style.left = self.VKI_keyboard.style.left;
        }
      }
    };


    if (window.addEventListener) {
      window.addEventListener('resize', this.VKI_position, false);
    } else if (window.attachEvent)
      window.attachEvent('onresize', this.VKI_position);


    /* ****************************************************************
     * Close the keyboard interface
     *
     */
    this.VKI_close = VKI_close = function() {
      if (this.VKI_visible) {
        try {
          this.VKI_keyboard.parentNode.removeChild(this.VKI_keyboard);
          if (this.VKI_isIE6) this.VKI_iframe.parentNode.removeChild(this.VKI_iframe);
        } catch (e) {}
        this.VKI_target.focus();
        this.VKI_target = this.VKI_visible = false;
      }
    };
  };

  function VKI_findPos(obj) {
    var curleft = curtop = 0;
    do {
      curleft += obj.offsetLeft;
      curtop += obj.offsetTop;
    } while (obj = obj.offsetParent);
    return [curleft, curtop];
  }

  function VKI_innerDimensions() {
    if (self.innerHeight) {
      return [self.innerWidth, self.innerHeight];
    } else if (document.documentElement && document.documentElement.clientHeight) {
      return [document.documentElement.clientWidth, document.documentElement.clientHeight];
    } else if (document.body)
      return [document.body.clientWidth, document.body.clientHeight];
    return [0, 0];
  }

  function VKI_scrollDist() {
    var html = document.getElementsByTagName('html')[0];
    if (html.scrollTop && document.documentElement.scrollTop) {
      return [html.scrollLeft, html.scrollTop];
    } else if (html.scrollTop || document.documentElement.scrollTop)
      return [html.scrollLeft + document.documentElement.scrollLeft, html.scrollTop + document.documentElement.scrollTop];
    return [0, 0];
  }

  function VKI_getStyle(obj, styleProp) {
    if (obj.currentStyle) {
      var y = obj.currentStyle[styleProp];
    } else if (window.getComputedStyle)
      var y = window.getComputedStyle(obj, null)[styleProp];
    return y;
  }

  function VKI_disableSelection(elem) {
    elem.onselectstart = function() { return false; };
    elem.unselectable = "on";
    elem.style.MozUserSelect = "none";
    elem.style.cursor = "default";
    if (window.opera) elem.onmousedown = function() { return false; };
  }


  /* ***** Attach this script to the onload event ****************** */
  if (window.addEventListener) {
    window.addEventListener('load', VKI_buildKeyboardInputs, false);
  } else if (window.attachEvent)
    window.attachEvent('onload', VKI_buildKeyboardInputs);