
// UniText namespace
if ("undefined" == typeof(UniText))
{
  var unitext = {};
};



// Controls the browser overlay for the extension
unitext =
{

  change : function(action, str)
  {

    var styles =
    {
      '00' : 'MAIÚSCULO',
      '01' : 'minúsculo',
      '02' : 'Capital',

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
      '23' : 'monoespacada',
      '24' : 'superescrito',
      '25' : 'subscrito',
      '26' : 'small caps',
      '27' : 'sublinhado'
    }

    var char;
    var newstr = '';
    var i = str.length;
    while (i--)
    {
      style  = charmap[ 'letras' ][ styles[action] ];
      char   = typeof  style[ str[i] ] != "undefined" ? style[ str[i] ][ 0 ] : str[i];
      newstr = char + newstr;
    }

    return newstr;

  },

  run : function (action)
  {

    var strings      = document.getElementById("unitext-string-bundle");

    var wm           = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    var mainWindow   = wm.getMostRecentWindow("navigator:browser");
    var tabBrowser   = mainWindow.getBrowser();
    var el           = tabBrowser.contentWindow.document.activeElement;
    if ( el.tagName.toLowerCase() == "textarea" || el.tagName.toLowerCase() == "input" )
    {
      if (el.selectionStart != el.selectionEnd)
      {
        var newText = el.value.substring(0, el.selectionStart)
                    + unitext.change(action, el.value.substring(el.selectionStart, el.selectionEnd))
                    + el.value.substring(el.selectionEnd);
        el.value = newText;
      }
    }
    else
    {
      alert(strings.getString("unitext.naoeditavel"));
    }

  }

}

