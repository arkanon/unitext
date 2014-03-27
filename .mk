#!/bin/bash

# UniText Unicode Character Style Replacer Firefox Extension
#
# Arkanon <arkanon@lsd.org.br>
# 0.0.2 - 2014/03/27 (Thu) 13:01:01 (BRS)
# 0.0.1 - 2014/03/27 (Thu) 10:13:37 (BRS)
#         2014/03/25 (Tue) 06:37:14 (BRS)
#         2014/03/25 (Tue) 02:49:55 (BRS)

# <http://blog.mozilla.org/addons/2009/01/28/how-to-develop-a-firefox-extension/>
# <http://robertnyman.com/2009/01/24/how-to-develop-a-firefox-extension/#comment-521990>
# <http://developer.mozilla.org/en-US/Add-ons/Overlay_Extensions/XUL_School>

# firefox -new-instance -p devel &

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
EXT_version="0.0.2"
EXT_type="2"
EXT_creator="Arkanon"
EXT_descr="Unicode Character Style Replacer"
EXT_home="http://github.com/arkanon/unitext"
EXT_locale="pt-BR"

EXT_tgtApp_id="{ec8030f7-c20a-464f-9b0e-13a3a9e97384}" # firefox
EXT_tgtApp_minVersion="1.0"
EXT_tgtApp_maxVersion="100.*"



echo "$HOME/git/$EXT/$EXT/" >| ~/.mozilla/firefox/devel/extensions/$EXT_id

mkdir -p content/
mkdir -p locale/$EXT_locale/
mkdir -p skin/



# <http://adblockplus.org/blog/web-pages-accessing-chrome-is-forbidden>
# <http://developer.mozilla.org/en-US/Add-ons/Install_Manifests>
# <http://developer.mozilla.org/en-US/docs/Chrome_Registration>



cat << EOT >| chrome.manifest
content   $EXT   content/
content   $EXT   content/          contentaccessible=yes
locale    $EXT   $EXT_locale             locale/$EXT_locale/
skin      $EXT   classic/1.0       skin/

overlay   chrome://browser/content/browser.xul           chrome://$EXT/content/browser.xul
style     chrome://global/content/customizeToolbar.xul   chrome://$EXT/skin/skin.css
EOT



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

    <!-- Mozilla Firefox -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_tgtApp_id</em:id>
        <em:minVersion >$EXT_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>

  </Description>

</RDF>
EOT



cat << EOT >| content/browser.xul
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

  <popup id="contentAreaContextMenu">

    <menu id="$EXT" label="&$EXT.label;" insertafter="context-selectall" class="menu-iconic">
      <menupopup>
        <menuitem id="$EXT.00" label="&$EXT.00.label;" oncommand="$EXT.run('00')" />
        <menuitem id="$EXT.01" label="&$EXT.01.label;" oncommand="$EXT.run('01')" />
        <menuitem id="$EXT.02" label="&$EXT.02.label;" oncommand="$EXT.run('02')" />
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
      </menupopup>
    </menu>

  </popup>

</overlay>
EOT



cat << EOT >| content/engine.js

// $EXT_name namespace
if ("undefined" == typeof($EXT_name))
{
  var $EXT = {};
};

// Controls the browser overlay for the extension
$EXT =
{

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

    var newstr = '';

         if (action=='00') newstr = str.toUpperCase();
    else if (action=='01') newstr = str.toLowerCase();
    else if (action=='02') newstr = $EXT.toTitleCase(str);
    else
    {
      var style, char;
      var i = str.length;
      while (i--)
      {
        style  = charmap[ 'letras' ][ styles[action] ];
        char   = typeof  style[ str[i] ] != "undefined" ? style[ str[i] ][ 0 ] : str[i];
        newstr = char + newstr;
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
    var el           = tabBrowser.contentWindow.document.activeElement;
    if ( el.tagName.toLowerCase() == "textarea" || el.tagName.toLowerCase() == "input" )
    {
      if (el.selectionStart != el.selectionEnd)
      {
        var newText = el.value.substring(0, el.selectionStart)
                    + $EXT.change(action, el.value.substring(el.selectionStart, el.selectionEnd))
                    + el.value.substring(el.selectionEnd);
        el.value = newText;
      }
    }
    else
    {
      alert(strings.getString("$EXT.naoeditavel"));
    }

  }

}

EOT



cat << EOT >| locale/$EXT_locale/translations.dtd

<!ENTITY $EXT.label    "$EXT_name"                        >

<!ENTITY $EXT.00.label "MAIÚSCULO"                        >
<!ENTITY $EXT.01.label "minúsculo"                        >
<!ENTITY $EXT.02.label "Capital"                          >

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



rm     ../$EXT_name-$EXT_version.xpi
zip -r ../$EXT_name-$EXT_version.xpi *



# EOF
