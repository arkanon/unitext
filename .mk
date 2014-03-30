#!/bin/bash

# UniText Unicode Character Style Replacer Mozilla Applications/Chrome Extension
#
# Arkanon <arkanon@lsd.org.br>
# 0.0.3 - 2014/03/30 (Sun) 01:34:17 (BRS)
#         2014/03/30 (Dom) 00:13:45 (BRS)
#         2014/03/29 (Sat) 14:44:38 (BRS)
# 0.0.2 - 2014/03/27 (Thu) 13:31:29 (BRS)
# 0.0.1 - 2014/03/27 (Thu) 10:13:37 (BRS)
#         2014/03/25 (Tue) 06:37:14 (BRS)
#         2014/03/25 (Tue) 02:49:55 (BRS)
#
#
# Status e versões
#   <http://addons.mozilla.org/developers/addon/unitext/versions>
#
# Detalhes
#   <http://addons.mozilla.org/developers/addon/unitext/edit>
#
# Estatísticas de download
#   <http://addons.mozilla.org/firefox/addon/unitext/statistics/?last=30>
#
#
# TODO
#
#  ok acrescentar os estilos leet básico, braille padrão, entre parênteses, circulado e fullwidth
#  -- acrescentar os estilos leet intermediário e avançado
#  ok juntar os dígitos às letras de mesmo estilo no array charmap, quando existirem
#  ok na conversão de letras com diacríticos para estilos sem o caracter equivalente, substituir pelo equivalente ASCII
#  -- tornar configurável a conversão dos diacríticos
#  -- na conversão para o estilo monoespaçado, utilizar o espaço ideográfico (U+3000)
#  -- usar a estrutura do array de estilos para montar o menu da extensão
#  -- usar os índices simbólicos do array de caracteres para montar a lista de opções no menu
#  -- usar um label simples no locale e convertê-lo usando o script para o estilo em questão
#  -- converter do estilo aplicado novamente para latin
#  ok minificar o código JS
#  -- tornar a extensão restarless <http://developer.mozilla.org/en-US/Add-ons/Bootstrapped_extensions>
#  -- versão para o Chrome
#     tornar compatível com
#      ok SeaMonkey Browser <http://developer.mozilla.org/en-US/Add-ons/SeaMonkey_2>
#      ok SeaMonkey HTML Editor
#      ok SeaMonkey Message Composer
#      -- Thunderbird Message Composer <http://developer.mozilla.org/en-US/Add-ons/Thunderbird>
#  -- efeitos com caracteres de combinação:
#       U+0305 (COMBINING OVERLINE)
#       U+0332 (COMBINING LOW LINE)
#       U+0333 (COMBINING DOUBLE LOW LINE)
#       U+0336 (COMBINING LONG STROKE OVERLAY)

# <http://blog.mozilla.org/addons/2009/01/28/how-to-develop-a-firefox-extension/>
# <http://robertnyman.com/2009/01/24/how-to-develop-a-firefox-extension/#comment-521990>
# <http://developer.mozilla.org/en-US/Add-ons/Overlay_Extensions/XUL_School>

# firefox   -new-instance -p devel &
# seamonkey -new-instance -p devel &

# about:config
#
#   javascript.options.showInConsole = true
#   nglayout.debug.disable_xul_cache = true  (def: don't exists)
#   browser.dom.window.dump.enabled  = true  (def: false)
#
#   javascript.options.strict  = true  (def: false)
#   extensions.logging.enabled = true  (def: false)



EXT="unitext"

EXT_id="$EXT@lsd.org.br"
EXT_name="UniText"
EXT_key="U"
EXT_version="0.0.3"
EXT_type="2"  # Extension
       # "4"  # Theme
       # "8"  # Locale
       # "32" # Multiple Item Package
       # "64" # Spell check dictionary
EXT_creator="Arkanon"
EXT_descr="Unicode Character Style Replacer"
EXT_home="http://github.com/arkanon/unitext"
EXT_locale="pt-BR"



# <http://addons.mozilla.org/firefox/pages/appversions/>

EXT_ff_tgtApp_id="{ec8030f7-c20a-464f-9b0e-13a3a9e97384}" # Firefox
EXT_ff_tgtApp_minVersion="3.0"
EXT_ff_tgtApp_maxVersion="31.0"

EXT_sm_tgtApp_id="{92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}" # SeaMonkey
EXT_sm_tgtApp_minVersion="1.0"
EXT_sm_tgtApp_maxVersion="2.28"

EXT_tb_tgtApp_id="{3550f703-e582-4d05-9a08-453d09bdfdc6}" # Thunderbird
EXT_tb_tgtApp_minVersion="1.0"
EXT_tb_tgtApp_maxVersion="31.0"

# "{aa3c5121-dab2-40e2-81ca-7ea25febc110}" # Firefox for Android
# "{a23983c0-fd0e-11dc-95ff-0800200c9a66}" # Mobile



MINIFIER="java -jar .more/yuicompressor-2.4.8.jar --type"



mkdir -p content/
mkdir -p locale/$EXT_locale/
mkdir -p skin/



# <http://developer.mozilla.org/en-US/Add-ons/Extension_etiquette>
# <http://developer.mozilla.org/en-US/Add-ons/Performance_best_practices_in_extensions>
# <http://developer.mozilla.org/en-US/Add-ons/Security_best_practices_in_extensions>
# <http://adblockplus.org/blog/web-pages-accessing-chrome-is-forbidden>



# <http://developer.mozilla.org/en-US/docs/Chrome_Registration>
cat << EOT >| chrome.manifest
content   $EXT   content/
content   $EXT   content/          contentaccessible=yes
locale    $EXT   $EXT_locale             locale/$EXT_locale/
skin      $EXT   classic/1.0       skin/

style     chrome://global/content/customizeToolbar.xul                       chrome://$EXT/skin/skin.css

# Firefox
overlay   chrome://browser/content/browser.xul                               chrome://$EXT/content/firefox+seamonkey.xul   application={ec8030f7-c20a-464f-9b0e-13a3a9e97384}

# SeaMonkey Browser
overlay   chrome://navigator/content/navigator.xul                           chrome://$EXT/content/firefox+seamonkey.xul   application={92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}

# SeaMonkey HTML Editor
overlay   chrome://editor/content/editor.xul                                 chrome://$EXT/content/firefox+seamonkey.xul   application={92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}

# Seamonkey Message Composer
overlay   chrome://messenger/content/messengercompose/messengercompose.xul   chrome://$EXT/content/firefox+seamonkey.xul   application={92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}

# Thunderbird Message Composer
overlay   chrome://messenger/content/messengercompose/messengercompose.xul   chrome://$EXT/content/thunderbird.xul         application={3550f703-e582-4d05-9a08-453d09bdfdc6}

# Thunderbird and Seamonkey Mail Main
#overlay   chrome://messenger/content/messenger.xul                           chrome://$EXT/content/browser.xul

# Thunderbird and Seamonkey Message Reader
#overlay   chrome://messenger/content/mailWindowOverlay.xul                   chrome://$EXT/content/browser.xul

# Thunderbird and SeaMonkey Address Book
#overlay   chrome://messenger/content/addressbook/addressbook.xul             chrome://$EXT/content/browser.xul
EOT



# <http://developer.mozilla.org/en-US/Add-ons/Install_Manifests>
cat << EOT >| install.rdf
<?xml version="1.0"?>

<RDF xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
     xmlns:em="http://www.mozilla.org/2004/em-rdf#">

  <Description about="urn:mozilla:install-manifest">

    <em:id          >$EXT_id</em:id>
    <em:name        >$EXT_name</em:name>
    <em:version     >$EXT_version</em:version>
    <em:type        >$EXT_type</em:type>
    <em:creator     >$EXT_creator</em:creator>
    <em:description >$EXT_descr</em:description>
    <em:homepageURL >$EXT_home</em:homepageURL>
    <em:iconURL     >chrome://$EXT/skin/icon-48x48.png</em:iconURL>
    <em:icon64URL   >chrome://$EXT/skin/icon-64x64.png</em:icon64URL>

    <!-- Firefox -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_ff_tgtApp_id</em:id>
        <em:minVersion >$EXT_ff_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_ff_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>

    <!-- SeaMonkey -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_sm_tgtApp_id</em:id>
        <em:minVersion >$EXT_sm_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_sm_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>

    <!-- Thunderbird -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_tb_tgtApp_id</em:id>
        <em:minVersion >$EXT_tb_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_tb_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>

  </Description>

</RDF>
EOT



for app in firefox+seamonkey:contentAreaContextMenu thunderbird:msgComposeContext
do
  cat << EOT >| content/$(echo $app | cut -d: -f1).xul
<?xml version="1.0"?>

<?xml-stylesheet type="text/css" href="chrome://global/skin/"?>
<?xml-stylesheet type="text/css" href="chrome://$EXT/skin/skin.css"?>

<!DOCTYPE overlay SYSTEM "chrome://$EXT/locale/translations.dtd">

<overlay id="$EXT-browser-overlay" xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">

  <script type="application/x-javascript" src="chrome://$EXT/content/engine.js" />
  <script type="application/x-javascript" src="chrome://$EXT/content/charmap.json" />

  <stringbundleset id="stringbundleset">
    <stringbundle id="$EXT-string-bundle" src="chrome://$EXT/locale/translations.properties" />
  </stringbundleset>

  <popup id="$(echo $app | cut -d: -f2)">

    <menu id="$EXT" label="&$EXT.label;" insertafter="context-selectall" class="menu-iconic">
      <menupopup>
        <menuitem id="$EXT.00" label="&$EXT.00.label;" oncommand="$EXT.run('00')" />
        <menuitem id="$EXT.01" label="&$EXT.01.label;" oncommand="$EXT.run('01')" />
        <menuitem id="$EXT.02" label="&$EXT.02.label;" oncommand="$EXT.run('02')" />
        <menuitem id="$EXT.28" label="&$EXT.28.label;" oncommand="$EXT.run('28')" />
        <menuitem id="$EXT.29" label="&$EXT.29.label;" oncommand="$EXT.run('29')" />
        <menuitem id="$EXT.30" label="&$EXT.30.label;" oncommand="$EXT.run('30')" />
        <menuitem id="$EXT.31" label="&$EXT.31.label;" oncommand="$EXT.run('31')" />
        <menuseparator/>
        <menuseparator/>
        <menuseparator/>
    <!-- menuitem id="$EXT.03" label="&$EXT.03.label;" oncommand="$EXT.run('03')" / -->
        <menuitem id="$EXT.04" label="&$EXT.04.label;" oncommand="$EXT.run('04')" />
        <menuitem id="$EXT.05" label="&$EXT.05.label;" oncommand="$EXT.run('05')" />
        <menuitem id="$EXT.06" label="&$EXT.06.label;" oncommand="$EXT.run('06')" />
        <menuitem id="$EXT.07" label="&$EXT.07.label;" oncommand="$EXT.run('07')" />
        <menuitem id="$EXT.08" label="&$EXT.08.label;" oncommand="$EXT.run('08')" />
        <menuitem id="$EXT.09" label="&$EXT.09.label;" oncommand="$EXT.run('09')" />
        <menuitem id="$EXT.10" label="&$EXT.10.label;" oncommand="$EXT.run('10')" />
        <menuitem id="$EXT.11" label="&$EXT.11.label;" oncommand="$EXT.run('11')" />
        <menuitem id="$EXT.12" label="&$EXT.12.label;" oncommand="$EXT.run('12')" />
        <menuitem id="$EXT.13" label="&$EXT.13.label;" oncommand="$EXT.run('13')" />
        <menuitem id="$EXT.14" label="&$EXT.14.label;" oncommand="$EXT.run('14')" />
        <menuitem id="$EXT.15" label="&$EXT.15.label;" oncommand="$EXT.run('15')" />
        <menuitem id="$EXT.16" label="&$EXT.16.label;" oncommand="$EXT.run('16')" />
        <menuitem id="$EXT.17" label="&$EXT.17.label;" oncommand="$EXT.run('17')" />
        <menuitem id="$EXT.18" label="&$EXT.18.label;" oncommand="$EXT.run('18')" />
        <menuitem id="$EXT.19" label="&$EXT.19.label;" oncommand="$EXT.run('19')" />
        <menuitem id="$EXT.20" label="&$EXT.20.label;" oncommand="$EXT.run('20')" />
        <menuitem id="$EXT.21" label="&$EXT.21.label;" oncommand="$EXT.run('21')" />
        <menuitem id="$EXT.22" label="&$EXT.22.label;" oncommand="$EXT.run('22')" />
        <menuitem id="$EXT.23" label="&$EXT.23.label;" oncommand="$EXT.run('23')" />
        <menuitem id="$EXT.24" label="&$EXT.24.label;" oncommand="$EXT.run('24')" />
        <menuitem id="$EXT.25" label="&$EXT.25.label;" oncommand="$EXT.run('25')" />
        <menuitem id="$EXT.26" label="&$EXT.26.label;" oncommand="$EXT.run('26')" />
        <menuitem id="$EXT.27" label="&$EXT.27.label;" oncommand="$EXT.run('27')" />
        <menuitem id="$EXT.32" label="&$EXT.32.label;" oncommand="$EXT.run('32')" />
        <menuitem id="$EXT.33" label="&$EXT.33.label;" oncommand="$EXT.run('33')" />
        <menuitem id="$EXT.34" label="&$EXT.34.label;" oncommand="$EXT.run('34')" />
        <menuitem id="$EXT.35" label="&$EXT.35.label;" oncommand="$EXT.run('35')" />
        <menuitem id="$EXT.36" label="&$EXT.36.label;" oncommand="$EXT.run('36')" />
      </menupopup>
    </menu>

  </popup>

</overlay>
EOT
done



cat << EOT >| .more/engine.js

// $EXT_name namespace
if ("undefined" == typeof($EXT_name)) var $EXT = {};

// Controls the browser overlay for the extension
$EXT =
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

    var strings      = document.getElementById("$EXT-string-bundle");

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

//    alert(strings.getString("$EXT.naoeditavel"));

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

EOT



cat << EOT >| locale/$EXT_locale/translations.dtd

<!ENTITY $EXT.label    "$EXT_name"                        >

<!ENTITY $EXT.00.label "MAIÚSCULO"                        >
<!ENTITY $EXT.01.label "minúsculo"                        >
<!ENTITY $EXT.02.label "Capital"                          >

<!ENTITY $EXT.28.label "Sobrelinhado"                     >
<!ENTITY $EXT.29.label "Sublinhado"                       >
<!ENTITY $EXT.30.label "Sublinhado Duplo"                 >
<!ENTITY $EXT.31.label "Tachado"                          >

<!ENTITY $EXT.03.label "Latin"                            >
<!ENTITY $EXT.04.label "𝖲𝖾𝗆 𝖲𝖾𝗋𝗂𝖿𝖺"                       >
<!ENTITY $EXT.05.label "𝗦𝗲𝗺 𝗦𝗲𝗿𝗶𝗳𝗮 𝗡𝗲𝗴𝗿𝗶𝘁𝗼"               >
<!ENTITY $EXT.06.label "𝘚𝘦𝘮 𝘚𝘦𝘳𝘪𝘧𝘢 𝘐𝘵𝘢𝘭𝘪𝘤𝘰"               >
<!ENTITY $EXT.07.label "𝙎𝙚𝙢 𝙎𝙚𝙧𝙞𝙛𝙖 𝙉𝙚𝙜𝙧𝙞𝙩𝙤 𝙄𝙩𝙖𝙡𝙞𝙘𝙤"       >
<!ENTITY $EXT.08.label "𝐂𝐨𝐦 𝐒𝐞𝐫𝐢𝐟𝐚 𝐍𝐞𝐠𝐫𝐢𝐭𝐨"               >
<!ENTITY $EXT.09.label "𝐶𝑜𝑚 𝑆𝑒𝑟𝑖𝑓𝑎 𝐼𝑡𝑎𝑙𝑖𝑐𝑜"               >
<!ENTITY $EXT.10.label "𝑪𝒐𝒎 𝑺𝒆𝒓𝒊𝒇𝒂 𝑵𝒆𝒈𝒓𝒊𝒕𝒐 𝑰𝒕𝒂𝒍𝒊𝒄𝒐"       >
<!ENTITY $EXT.11.label "Γρεγο Sem Serifa"                 >
<!ENTITY $EXT.12.label "𝝘𝞀𝝴𝝲𝝾 Sem Serifa Negrito"         >
<!ENTITY $EXT.13.label "𝞒𝞺𝞮𝞬𝞸 Sem Serifa Negrito Italico" >
<!ENTITY $EXT.14.label "𝚪𝛒𝛆𝛄𝛐 Com Serifa Negrito"         >
<!ENTITY $EXT.15.label "𝛤𝜌𝜀𝛾𝜊 Com Serifa Italico"         >
<!ENTITY $EXT.16.label "𝜞𝝆𝜺𝜸𝝄 Com Serifa Negrito Italico" >
<!ENTITY $EXT.17.label "𝔊𝔬𝔱𝔦𝔠𝔬"                           >
<!ENTITY $EXT.18.label "𝕲𝖔𝖙𝖎𝖈𝖔 𝕹𝖊𝖌𝖗𝖎𝖙𝖔"                   >
<!ENTITY $EXT.19.label "𝒮𝒸𝓇𝒾𝓅𝓉"                           >
<!ENTITY $EXT.20.label "𝓢𝓬𝓻𝓲𝓹𝓽 𝓝𝓮𝓰𝓻𝓲𝓽𝓸"                   >
<!ENTITY $EXT.21.label "Ʌᴉɹɐpo"                           >
<!ENTITY $EXT.22.label "𝔻𝕦𝕡𝕝𝕠"                            >
<!ENTITY $EXT.23.label "𝙼𝚘𝚗𝚘𝚎𝚜𝚙𝚊𝚌𝚊𝚍𝚊"                     >
<!ENTITY $EXT.24.label "ˢᵘᵖᵉʳᵉˢᶜʳⁱᵗᵒ"                     >
<!ENTITY $EXT.25.label "Sᵤ ₛ ᵣᵢₜₒ"                        >
<!ENTITY $EXT.26.label "Sᴍᴀʟʟ Cᴀᴘꜱ"                       >
<!ENTITY $EXT.27.label "Suḇḻiṉẖaḏo"                       >

<!ENTITY $EXT.32.label "⠠⠃⠗⠁⠊⠇⠇⠑ Padrao"                  >
<!ENTITY $EXT.33.label "Ⓒⓘⓡⓒⓤⓛⓐⓓⓞ"                        >
<!ENTITY $EXT.34.label "E⒩⒯⒭⒠ P⒜⒭⒠⒩⒯⒠⒮⒠⒮"                 >
<!ENTITY $EXT.35.label "Ｆｕｌｌｗｉｄｔｈ Ｌａｔｉｎ"    >
<!ENTITY $EXT.36.label "Leet 845!(0"                      >

EOT



cat << EOT >| locale/$EXT_locale/translations.properties
$EXT.naoeditavel = Selecione texto em algum campo editável.
EOT



cat << EOT >| skin/skin.css

#$EXT
{
  list-style-image: URL("chrome://$EXT/skin/icon-16x16.png");
}

EOT



# por enquanto, os campos índice 1 e 2 do mapa de caracteres não estão sendo usados
cat .more/charmap.json | sed -r "s/(: *\[ *'[^']+') *, *'[^]]*]/\1 ]/g" >| .more/charmap0.json

echo

for f in engine.js charmap0.json
do
  cp -a .more/$f content/$f
# cat .more/$f | $MINIFIER js >| content/$f
# ft=%\'6d
# s1=$(stat -c %s   .more/$f)
# s2=$(stat -c %s content/$f)
# df=$(bc<<<"scale=9;100*(1-$s2/$s1)" | tr . ,)
# export LC_NUMERIC=
# echo -e "$f:\t$(printf $ft $s1) -> $(printf $ft $s2) ($(printf '%6.3f' $df)% menor)"
done

mv content/charmap0.json content/charmap.json
rm .more/charmap0.json



rm      .extension/$EXT_name-$EXT_version.xpi
zip -qr .extension/$EXT_name-$EXT_version.xpi *
ln -fs             $EXT_name-$EXT_version.xpi .extension/$EXT_name.xpi

ln -nfs ../.thunderbird $HOME/.mozilla/thunderbird
for app in firefox seamonkey thunderbird
do
  mkdir -p                               $HOME/.mozilla/$app/devel/extensions/
# echo   "$PWD/"                      >| $HOME/.mozilla/$app/devel/extensions/$EXT_id
# ln -fs "$PWD/.extension/$EXT_name.xpi" $HOME/.mozilla/$app/devel/extensions/$EXT_id.xpi
  cp -aL       .extension/$EXT_name.xpi  $HOME/.mozilla/$app/devel/extensions/$EXT_id.xpi
done



f=$EXT_name-$EXT_version.xpi
echo -e "\n$f: $(printf $ft $(stat -c %s .extension/$f))\n"



# EOF
