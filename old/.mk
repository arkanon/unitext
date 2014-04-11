#!/bin/bash

# UniText Unicode Character Style Replacer Firefox Extension
#
# Arkanon <arkanon@lsd.org.br>
# 2014/03/27 (Thu) 10:13:37 (BRS)
# 2014/03/25 (Tue) 06:37:14 (BRS)
# 2014/03/25 (Tue) 02:49:55 (BRS)

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

EXT_id="unitext@lsd.org.br"
EXT_name="UniText"
EXT_key="U"
EXT_version="0.0.1"
EXT_type="2"
EXT_creator="Arkanon"
EXT_descr="Unicode Character Style Replacer"
EXT_home="http://www.lsd.org.br/"
EXT_locale="pt-BR"

EXT_tgtApp_id="{ec8030f7-c20a-464f-9b0e-13a3a9e97384}" # firefox
EXT_tgtApp_minVersion="1.0"
EXT_tgtApp_maxVersion="100.*"



echo "$HOME/git/$EXT/" >| ~/.mozilla/firefox/devel/extensions/$EXT_id

mkdir -p content/
mkdir -p defaults/preferences/
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
    <em:optionsURL  >chrome://$EXT/content/options.xul</em:optionsURL>

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

  <script type="application/x-javascript" src="chrome://$EXT/content/extension.js" />
  <script type="application/x-javascript" src="chrome://$EXT/content/charmap.json" />

  <stringbundleset id="stringbundleset">
    <stringbundle id="$EXT-string-bundle" src="chrome://$EXT/locale/translations.properties" />
  </stringbundleset>

  <popup id="contentAreaContextMenu">

    <menuitem id="$EXT.27" accesskey="&$EXT.27.key;" label="&$EXT.27.label;" oncommand="$EXT.run('27')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.26" accesskey="&$EXT.26.key;" label="&$EXT.26.label;" oncommand="$EXT.run('26')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.25" accesskey="&$EXT.25.key;" label="&$EXT.25.label;" oncommand="$EXT.run('25')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.24" accesskey="&$EXT.24.key;" label="&$EXT.24.label;" oncommand="$EXT.run('24')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.23" accesskey="&$EXT.23.key;" label="&$EXT.23.label;" oncommand="$EXT.run('23')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.22" accesskey="&$EXT.22.key;" label="&$EXT.22.label;" oncommand="$EXT.run('22')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.21" accesskey="&$EXT.21.key;" label="&$EXT.21.label;" oncommand="$EXT.run('21')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.20" accesskey="&$EXT.20.key;" label="&$EXT.20.label;" oncommand="$EXT.run('20')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.19" accesskey="&$EXT.19.key;" label="&$EXT.19.label;" oncommand="$EXT.run('19')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.18" accesskey="&$EXT.18.key;" label="&$EXT.18.label;" oncommand="$EXT.run('18')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.17" accesskey="&$EXT.17.key;" label="&$EXT.17.label;" oncommand="$EXT.run('17')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.16" accesskey="&$EXT.16.key;" label="&$EXT.16.label;" oncommand="$EXT.run('16')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.15" accesskey="&$EXT.15.key;" label="&$EXT.15.label;" oncommand="$EXT.run('15')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.14" accesskey="&$EXT.14.key;" label="&$EXT.14.label;" oncommand="$EXT.run('14')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.13" accesskey="&$EXT.13.key;" label="&$EXT.13.label;" oncommand="$EXT.run('13')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.12" accesskey="&$EXT.12.key;" label="&$EXT.12.label;" oncommand="$EXT.run('12')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.11" accesskey="&$EXT.11.key;" label="&$EXT.11.label;" oncommand="$EXT.run('11')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.10" accesskey="&$EXT.10.key;" label="&$EXT.10.label;" oncommand="$EXT.run('10')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.09" accesskey="&$EXT.09.key;" label="&$EXT.09.label;" oncommand="$EXT.run('09')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.08" accesskey="&$EXT.08.key;" label="&$EXT.08.label;" oncommand="$EXT.run('08')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.07" accesskey="&$EXT.07.key;" label="&$EXT.07.label;" oncommand="$EXT.run('07')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.06" accesskey="&$EXT.06.key;" label="&$EXT.06.label;" oncommand="$EXT.run('06')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.05" accesskey="&$EXT.05.key;" label="&$EXT.05.label;" oncommand="$EXT.run('05')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.04" accesskey="&$EXT.04.key;" label="&$EXT.04.label;" oncommand="$EXT.run('04')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.03" accesskey="&$EXT.03.key;" label="&$EXT.03.label;" oncommand="$EXT.run('03')" insertafter="context-selectall" class="$EXT menuitem-iconic" />

    <menuitem id="$EXT.02" accesskey="&$EXT.02.key;" label="&$EXT.02.label;" oncommand="$EXT.run('02')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.01" accesskey="&$EXT.01.key;" label="&$EXT.01.label;" oncommand="$EXT.run('01')" insertafter="context-selectall" class="$EXT menuitem-iconic" />
    <menuitem id="$EXT.00" accesskey="&$EXT.00.key;" label="&$EXT.00.label;" oncommand="$EXT.run('00')" insertafter="context-selectall" class="$EXT menuitem-iconic" />

  </popup>

</overlay>
EOT



cat << EOT >| content/options.xul
<?xml version="1.0"?>

<?xml-stylesheet href="chrome://global/skin/" type="text/css"?>

<prefwindow
  title="$EXT_name Preferences"
  xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">

  <prefpane label="$EXT_name Preferences">

    <preferences>
      <preference id="$EXT-autorun" name="extensions.$EXT.autorun" type="bool"/>
    </preferences>

    <groupbox>
      <caption label="Settings"/>
      <grid>

        <columns>
          <column flex="4"/>
          <column flex="1"/>
        </columns>

        <rows>
          <row>
            <label control="autorun" value="Autorun"/>
            <checkbox id="autorun" preference="$EXT-autorun"/>
          </row>
        </rows>

      </grid>
    </groupbox>

  </prefpane>

</prefwindow>
EOT



cat << EOT >| content/extension.js

// $EXT_name namespace
if ("undefined" == typeof($EXT_name))
{
  var $EXT = {};
};



// Controls the browser overlay for the extension
$EXT =
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



cat << EOT >| defaults/preferences/pref.js
pref("extensions.$EXT.autorun", false);
EOT



cat << EOT >| locale/$EXT_locale/translations.dtd

<!ENTITY $EXT.00.label "$EXT_name: MAIÚSCULO"                        > <!ENTITY $EXT.00.key "m" >
<!ENTITY $EXT.01.label "$EXT_name: minúsculo"                        > <!ENTITY $EXT.01.key "m" >
<!ENTITY $EXT.02.label "$EXT_name: Capital"                          > <!ENTITY $EXT.02.key "m" >

<!ENTITY $EXT.03.label "$EXT_name: latin"                            > <!ENTITY $EXT.03.key "m" >
<!ENTITY $EXT.04.label "$EXT_name: sem serifa"                       > <!ENTITY $EXT.04.key "m" >
<!ENTITY $EXT.05.label "$EXT_name: sem serifa negrito"               > <!ENTITY $EXT.05.key "m" >
<!ENTITY $EXT.06.label "$EXT_name: sem serifa italico"               > <!ENTITY $EXT.06.key "m" >
<!ENTITY $EXT.07.label "$EXT_name: sem serifa negrito italico"       > <!ENTITY $EXT.07.key "m" >
<!ENTITY $EXT.08.label "$EXT_name: com serifa negrito"               > <!ENTITY $EXT.08.key "m" >
<!ENTITY $EXT.09.label "$EXT_name: com serifa italico"               > <!ENTITY $EXT.09.key "m" >
<!ENTITY $EXT.10.label "$EXT_name: com serifa negrito italico"       > <!ENTITY $EXT.10.key "m" >
<!ENTITY $EXT.11.label "$EXT_name: grego sem serifa"                 > <!ENTITY $EXT.11.key "m" >
<!ENTITY $EXT.12.label "$EXT_name: grego sem serifa negrito"         > <!ENTITY $EXT.12.key "m" >
<!ENTITY $EXT.13.label "$EXT_name: grego sem serifa negrito italico" > <!ENTITY $EXT.13.key "m" >
<!ENTITY $EXT.14.label "$EXT_name: grego com serifa negrito"         > <!ENTITY $EXT.14.key "m" >
<!ENTITY $EXT.15.label "$EXT_name: grego com serifa italico"         > <!ENTITY $EXT.15.key "m" >
<!ENTITY $EXT.16.label "$EXT_name: grego com serifa negrito italico" > <!ENTITY $EXT.16.key "m" >
<!ENTITY $EXT.17.label "$EXT_name: gotico"                           > <!ENTITY $EXT.17.key "m" >
<!ENTITY $EXT.18.label "$EXT_name: gotico negrito"                   > <!ENTITY $EXT.18.key "m" >
<!ENTITY $EXT.19.label "$EXT_name: script"                           > <!ENTITY $EXT.19.key "m" >
<!ENTITY $EXT.20.label "$EXT_name: script negrito"                   > <!ENTITY $EXT.20.key "m" >
<!ENTITY $EXT.21.label "$EXT_name: virado"                           > <!ENTITY $EXT.21.key "m" >
<!ENTITY $EXT.22.label "$EXT_name: duplo"                            > <!ENTITY $EXT.22.key "m" >
<!ENTITY $EXT.23.label "$EXT_name: monoespacada"                     > <!ENTITY $EXT.23.key "m" >
<!ENTITY $EXT.24.label "$EXT_name: superescrito"                     > <!ENTITY $EXT.24.key "m" >
<!ENTITY $EXT.25.label "$EXT_name: subscrito"                        > <!ENTITY $EXT.25.key "m" >
<!ENTITY $EXT.26.label "$EXT_name: small caps"                       > <!ENTITY $EXT.26.key "m" >
<!ENTITY $EXT.27.label "$EXT_name: sublinhado"                       > <!ENTITY $EXT.27.key "m" >

EOT



cat << EOT >| locale/$EXT_locale/translations.properties
$EXT.naoeditavel = Selecione texto em algum campo editável.
EOT



cat << EOT >| skin/skin.css

.$EXT
{
  list-style-image: URL("chrome://$EXT/skin/unicode-16x16.png");
}

EOT



# zip -r ../$EXT_name-$EXT_version.xpi *



# EOF
