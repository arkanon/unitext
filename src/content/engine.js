
if (typeof unitext == 'undefined') var unitext = {}; // UniText namespace

// Controls the browser overlay for the extension
unitext =
{



  $ : function(id)
  {
    return document.getElementById(id);
  },



  onPopupShowing : function()
  {
    var strings = this.$('unitext-string-bundle');
    var arr1    = Array.prototype.slice.call(this.$('unitext').getElementsByTagName('menuitem')); // <http://stackoverflow.com/a/222847>
    var arr2    = Array.prototype.slice.call(this.$('unitext').getElementsByTagName('menu'    ));
    for (var i in arr1) arr1[i].label = strings.getString(arr1[i].id) + ' (' + this.change(arr1[i].id.split('-')[1],strings.getString('unitext-exemplo')) + ')';
    for (var i in arr2) arr2[i].label = strings.getString(arr2[i].id);
  },



  onLoad : function(e)
  {
    window.removeEventListener('load', this.onLoad, false);
    for (var i=0; i<this.defaultDiacriticsRemovalap.length; i++)
    {
      var letters = this.defaultDiacriticsRemovalap[i][1].split('');
      for (var j=0; j<letters.length; j++) this.diacriticsMap[letters[j]] = this.defaultDiacriticsRemovalap[i][0];
    }
  },



  removeDiacritics : function(str)
  // 'what?' version ... <http://jsperf.com/diacritics/12>
  {
    return str.replace( /[^\u0000-\u007E]/g, function(a) { return unitext.diacriticsMap[a] || a } );
  },



  addChar : function(str,char)
  {
    var newstr = '';
    for (var i in str) newstr += str[i] + char;
    return newstr;
  },



  toTitleCase : function(str)
  {
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
  },



  swapCase : function(str)
  {
    var newstr = '';
    for (var i in str) newstr += str[i] == str[i].toUpperCase() ? str[i].toLowerCase() : str[i].toUpperCase();
    return newstr;
  },



  reverse : function(str)
  // <http://stackoverflow.com/a/16776621>
  // <http://mths.be/esrever> v0.1.0 by @mathias
  // teste com 'foo 𝌆 bar mañana mañana'
  // via [ str.split('').reverse().join('') ]: anãnam anañam rab �� oof
  {

    var regexSymbolWithCombiningMarks = /([\0-\u02FF\u0370-\u1DBF\u1E00-\u20CF\u2100-\uD7FF\uDC00-\uFE1F\uFE30-\uFFFF]|[\uD800-\uDBFF][\uDC00-\uDFFF]|[\uD800-\uDBFF])([\u0300-\u036F\u1DC0-\u1DFF\u20D0-\u20FF\uFE20-\uFE2F]+)/g;
    var regexSurrogatePair            = /([\uD800-\uDBFF])([\uDC00-\uDFFF])/g;

    // step 1: deal with combining marks and astral symbols (surrogate pairs)
    str = str
      .replace // swap symbols with their combining marks so the combining marks go first
      (
        regexSymbolWithCombiningMarks,
        function($0, $1, $2) { return unitext.reverse($2) + $1 } // reverse the combining marks so they will end up in the same order later on (after another round of reversing)
      )
      .replace(regexSurrogatePair, '$2$1'); // Swap high and low surrogates so the low surrogates go first

    // step 2: reverse the code units in the string
    var result = '';
    var index  = str.length;
    while (index--) result += str.charAt(index);
    return result;

  },



  change : function(action,str)
  {

    var styles =
    {

      '00'   : 'maiusculo',
      '01'   : 'minusculo',
      '02'   : 'capital',
      '38'   : 'invertido',
      '39'   : 'trocar caixa',

      '28'   : 'sobrelinhado',
      '29'   : 'sublinhado',
      '30'   : 'sublinhado duplo',
      '31'   : 'tachado',

      '03'   : 'latino',
      '03.1' : 'sem serifa',
      '03.2' : 'sem serifa negrito',
      '03.3' : 'sem serifa italico',
      '03.4' : 'sem serifa negrito italico',
      '03.5' : 'com serifa negrito',
      '03.6' : 'com serifa italico',
      '03.7' : 'com serifa negrito italico',

      '11'   : 'grego',
      '11.1' : 'sem serifa',
      '11.2' : 'sem serifa negrito',
      '11.3' : 'sem serifa italico',
      '11.4' : 'sem serifa negrito italico',
      '11.5' : 'com serifa negrito',
      '11.6' : 'com serifa italico',
      '11.7' : 'com serifa negrito italico',

      '17'   : 'gotico',
      '18'   : 'gotico negrito',
      '19'   : 'script',
      '20'   : 'script negrito',
      '21'   : 'virado',
      '37'   : 'virado', // invertido
      '22'   : 'duplo',
      '23'   : 'monoespacado',
      '24'   : 'superescrito',
      '25'   : 'subscrito',
      '26'   : 'small caps',

      '32'   : 'braille padrao',
      '33'   : 'circulado',
      '34'   : 'entre parenteses',
      '35'   : 'fullwidth latin',
      '36'   : 'leet basico'

    }

    var newstr = '';

         if (action=='37')    str = this.reverse(str);
         if (action=='23')    str = str.replace(/ /g,'\u3000');
         if (action=='00') newstr = str.toUpperCase();
    else if (action=='01') newstr = str.toLowerCase();
    else if (action=='02') newstr = this.toTitleCase(str);
    else if (action=='38') newstr = this.reverse(str);
    else if (action=='39') newstr = this.swapCase(str);
    else if (action=='28') newstr = this.addChar(str,'\u0305'); // combining overline
    else if (action=='29') newstr = this.addChar(str,'\u0332'); // combining low line
    else if (action=='30') newstr = this.addChar(str,'\u0333'); // combining double low line
    else if (action=='31') newstr = this.addChar(str,'\u0336'); // combining long stroke overlay
    else
    {

   // alert(JSON.stringify(this.diacriticsMap)); // só como exemplo. Pau no Firefox ao tentar mostrar string tão grande.
      str = this.removeDiacritics(str);

      var parent     = this.charmap[ 'letras' ];
      var action_arr = action.split('.');
      if ( action_arr.length > 1 ) parent = parent[ styles[action_arr[0]] ];

      if ( Object.keys(parent).indexOf(styles[action]) > -1 )
      {
        var chr;
        var style = parent[ styles[action] ];
        var i     = str.length;
        while (i--)
        {
          chr    = typeof  style[ str[i] ] != "undefined" ? style[ str[i] ][ 0 ] : str[i];
          newstr = chr + newstr;
        }
      }

    }

    return newstr;

  },



  run : function(obj)
  {

    var action       = obj.id.split('-')[1];

    var strings      = this.$('unitext-string-bundle');

    var wm           = Components.classes['@mozilla.org/appshell/window-mediator;1'].getService(Components.interfaces.nsIWindowMediator);
    var mainWindow   = wm.getMostRecentWindow('navigator:browser');

    var tabBrowser   = mainWindow.getBrowser();
    var doc          = tabBrowser.contentWindow.document;

    var el           = doc.activeElement;

//  alert(el.tagName);

    if ( el.tagName.toLowerCase() == 'textarea' || el.tagName.toLowerCase() == 'input' )
    {
      if (el.selectionStart != el.selectionEnd)
      {
        var newText = el.value.substring(0, el.selectionStart)
                    + this.change(action, el.value.substring(el.selectionStart, el.selectionEnd))
                    + el.value.substring(el.selectionEnd);
        el.value = newText;
      }
    }
    else
    {

      // <http://www.filewatcher.com/p/lightning-extension_1.0~b2+build2+nobinonly.orig.tar.bz2.66826823/lightning-extension-1.0~b2+build2+nobinonly/editor/ui/dialogs/content/EdInputImage.js.html>
      // <http://bitbucket.org/ondrejd/tbnotes/src/2d870500b2c78ef59bbaef2ebd039c83c2226883/content/bindings.xml?at=default>
      var editor = GetCurrentEditor();
      editor.beginTransaction();

//    alert(strings.getString('unitext-naoeditavel'));

      let span         = doc.createElement('span');
      var selectedtext = this.isSelection();
//    alert(selectedtext);

      span.textContent = this.change(action, selectedtext);
//    alert(span.textContent);

      // <https://developer.mozilla.org/en-US/docs/XPCOM_Interface_Reference/nsIHTMLEditor#insertElementAtSelection%28%29>
      editor.insertElementAtSelection(span, true);

    }

  },



  isSelection : function()
  // return selected text if there is any
  {
    var thisselection = document.commandDispatcher.focusedWindow.getSelection();
    var thistext = thisselection.toString();
    if(thistext){ return thistext;}
    return false;
  }



}

window.addEventListener('load', function(e){ unitext.onLoad(e); }, false);

