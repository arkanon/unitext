
// UniText namespace
if ("undefined" == typeof(UniText)) var unitext = {};

// Controls the browser overlay for the extension
unitext =
{



  onLoad : function(e)
  {
    window.removeEventListener('load', this.onLoad, false);
    for (var i=0; i<this.defaultDiacriticsRemovalap.length; i++)
    {
      var letters = this.defaultDiacriticsRemovalap[i][1].split("");
      for (var j=0; j<letters.length; j++) this.diacriticsMap[letters[j]] = this.defaultDiacriticsRemovalap[i][0];
    }
  },



  removeDiacritics : function(str)
  // "what?" version ... <http://jsperf.com/diacritics/12>
  {
    return str.replace( /[^\u0000-\u007E]/g, function(a) { return this.diacriticsMap[a] || a } );
  },



  toTitleCase : function(str)
  {
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
  },



  change : function(action, str)
  {

    var styles =
    {
      '00' : 'MAIÚSCULO',
      '01' : 'minúsculo',
      '02' : 'Capital',
      '28' : 'Sobrelinhado',
      '29' : 'Sublinhado',
      '30' : 'Sublinhado Duplo',
      '31' : 'Tachado',

      '03' : 'latin',
      '04' : 'sem serifa',
      '05' : 'sem serifa negrito',
      '06' : 'sem serifa italico',
      '07' : 'sem serifa negrito italico',
      '08' : 'com serifa negrito',
      '09' : 'com serifa italico',
      '10' : 'com serifa negrito italico',
      '11' : 'grego sem serifa',
      '12' : 'grego sem serifa negrito',
      '13' : 'grego sem serifa negrito italico',
      '14' : 'grego com serifa negrito',
      '15' : 'grego com serifa italico',
      '16' : 'grego com serifa negrito italico',
      '17' : 'gotico',
      '18' : 'gotico negrito',
      '19' : 'script',
      '20' : 'script negrito',
      '21' : 'virado',
      '22' : 'duplo',
      '23' : 'monoespacado',
      '24' : 'superescrito',
      '25' : 'subscrito',
      '26' : 'small caps',
      '27' : 'sublinhado',
      '32' : 'braille padrao',
      '33' : 'circulado',
      '34' : 'entre parenteses',
      '35' : 'fullwidth latin',
      '36' : 'leet basico'

    }

    var newstr = '';

         if (action=='00') newstr = str.toUpperCase();
    else if (action=='01') newstr = str.toLowerCase();
    else if (action=='02') newstr = this.toTitleCase(str);
    else if (action=='28') newstr = this.addChar(''); // sobrelinhado
    else if (action=='29') newstr = this.addChar(''); // sublinhado
    else if (action=='30') newstr = this.addChar(''); // sublinhado duplo
    else if (action=='31') newstr = this.addChar(''); // tachado
    else
    {

   // alert(JSON.stringify(this.diacriticsMap)); // só como exemplo. Pau no Firefox ao tentar mostrar string tão grande.
      str = this.removeDiacritics(str);

      var style, chr;
      var i = str.length;
      while (i--)
      {
        style  = this.charmap[ 'letras' ][ styles[action] ];
        chr    = typeof  style[ str[i] ] != "undefined" ? style[ str[i] ][ 0 ] : str[i];
        newstr = chr + newstr;
      }

    }

    return newstr;

  },



  run : function (action)
  {

    var strings      = document.getElementById("unitext-string-bundle");

    var wm           = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    var mainWindow   = wm.getMostRecentWindow("navigator:browser");

    var tabBrowser   = mainWindow.getBrowser();
    var doc          = tabBrowser.contentWindow.document;

    var el           = doc.activeElement;

    alert(el.tagName);

    if ( el.tagName.toLowerCase() == "textarea" || el.tagName.toLowerCase() == "input" )
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

//    alert(strings.getString("unitext.naoeditavel"));

      let span         = doc.createElement("span");
      var selectedtext = this.IsSelection();
      alert(selectedtext);

      span.textContent = this.change(action, selectedtext);
      alert(span.textContent);

      // <https://developer.mozilla.org/en-US/docs/XPCOM_Interface_Reference/nsIHTMLEditor#insertElementAtSelection%28%29>
      editor.insertElementAtSelection(span, true);

    }

  },



  //return the selected text if there is any
  IsSelection: function()
  {
    var thisselection = document.commandDispatcher.focusedWindow.getSelection();
    var thistext = thisselection.toString();
    if(thistext){ return thistext;}
    return false;
  }



}

window.addEventListener("load", function(e){ this.onLoad(e); }, false);

