#!/bin/bash

# UniText Unicode Character Style Replacer MozillaApps/Chrome Extension
#
# Arkanon <arkanon@lsd.org.br>
# 0.3.333 - 2014/04/11 (Fri) 11:49:52 (BRS)
# 0.2.109 - 2014/03/27 (Thu) 13:31:37 (BRS)
# 0.1.72  - 2014/03/27 (Thu) 10:13:37 (BRS)
# 0.0.0   - 2014/03/25 (Tue) 02:49:55 (BRS)


# Status e versões
#   <http://addons.mozilla.org/developers/addon/unitext/versions>
#
# Detalhes
#   <http://addons.mozilla.org/developers/addon/unitext/edit>
#
# Estatísticas de download
#   <http://addons.mozilla.org/firefox/addon/unitext/statistics/?last=30>


# BUGS
#
#  -- caracteres unicode totalmente incompletos no xp (mesmo com fontes com suporte a leste asiático instaladas)
#  -- não gera direito os labels no windows 8
#  PERFEITO NO XP do Eduardo E NO W7 DA Tais
#
#  -- não funciona na edição de arquivos do GitHub

# TODO

#  tornar compatível com
#     o- aparece o menu certo, mas não aplica                               Thunderbird Message Composer <http://developer.mozilla.org/en-US/Add-ons/Thunderbird>
#     o- só aplica se o browser estiver aberto sem foco em campo editavel   SeaMonkey Message Composer
#     -- o menu aparece mas sem os labels                                   SeaMonkey HTML Editor
#
#  -- adicionar como submenu do menu Editar sem copiar todo o código XUL do menu
#  -- adicionar como botões de ferramentas no campo textarea.
#
#  -- palete unicode
#  -- permitir criar palete personalizada
#
#  -- usar a seleção como exemplo no menu
#  -- tornar configurável o uso da seleção como exemplo no menu
#  -- acrescentar opção de copiar a seleção convertida apresentada como exemplo no menu para a área de transferência
#
#  -- tornar a extensão restarless <http://developer.mozilla.org/en-US/Add-ons/Bootstrapped_extensions>
#  -- fazer acentos com caracteres de combinação
#  -- converter do estilo aplicado novamente para latino
#  -- tornar configurável a conversão dos diacríticos
#  -- usar a estrutura do array de estilos para montar o menu da extensão
#  -- versão para o Chrome/Chromium
#  -- acrescentar os estilos leet intermediário e avançado

# HISTORY

#  0.4.337
#  ok incluir a compatibilidade com o Firefox for Android e Mobile Firefox

#  0.4.336
#  ok configurar a compatibilidade para partir do Firefox 10.0

#  0.4.335
#  ok deixar apenas uma tag separando os grupos no menu
#  ok mover 'fullwidth latin' para submenu 'latin'

#  0.3.333
#  ok subir os sub-menus Latin e Greek
#  ok remover opção inativa de 'grego sem serifa itálico'
#  ok acrescentar os estilos leet básico, braille padrão, entre parênteses, circulado e fullwidth
#  ok função invertido
#  ok função trocar caixa
#  ok juntar os dígitos às letras de mesmo estilo no array charmap, quando existirem
#  ok na conversão de letras com diacríticos para estilos sem o caracter equivalente, substituir pelo equivalente ASCII
#  ok na conversão para o estilo monoespaçado, substituir os espaços pelo caracter U+3000 (IDEOGRAPHIC SPACE) <http://www.cs.tut.fi/~jkorpela/chars/spaces.html>
#  ok adicionar automaticamente ao lado da opção do menu uma string de exemplo no estilo em questão no locale em questão
#  ok minificar o código JS (desabilitado por enquanto)
#  ok locale para en-US
#  ok compatível com SeaMonkey Browser <http://developer.mozilla.org/en-US/Add-ons/SeaMonkey_2>
#  ok efeitos com caracteres de combinação:
#       U+0305 (COMBINING OVERLINE)
#       U+0332 (COMBINING LOW LINE)
#       U+0333 (COMBINING DOUBLE LOW LINE)
#       U+0336 (COMBINING LONG STROKE OVERLAY)


# <http://blog.mozilla.org/addons/2009/01/28/how-to-develop-a-firefox-extension/>
# <http://robertnyman.com/2009/01/24/how-to-develop-a-firefox-extension/#comment-521990>
# <http://developer.mozilla.org/en-US/Add-ons/Overlay_Extensions/XUL_School>

# LD_LIBRARY_PATH=firefox-10.0 firefox-10.0/firefox -p devel -no-remote & # <http://oldapps.com/linux/firefox.php?system=ubuntu>
# firefox     -p devel -no-remote &
# thunderbird -p devel -compose   &
# seamonkey   -p devel -browser   &
# seamonkey   -p devel -compose   &
# seamonkey   -p devel -edit      &

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
EXT_type="2"  # Extension
       # "4"  # Theme
       # "8"  # Locale
       # "32" # Multiple Item Package
       # "64" # Spell check dictionary
EXT_creator="Arkanon"
EXT_descr="Unicode Character Style Replacer"
EXT_home="http://github.com/arkanon/unitext"

EXT_major="0.4"

EXT_build=$(($(tail -n1 .build-history | cut -f1)+1)) # update build number
EXT_version="$EXT_major.$EXT_build"
echo -e "$EXT_build\t$(LC_TIME=C date +'%Y/%m/%d (%a) %H:%M:%S (%Z)')" >> .build-history



# <http://addons.mozilla.org/firefox/pages/appversions/>

EXT_ff_tgtApp_id="{ec8030f7-c20a-464f-9b0e-13a3a9e97384}" # Firefox
EXT_ff_tgtApp_minVersion="10.0"
EXT_ff_tgtApp_maxVersion="32.0"

EXT_fa_tgtApp_id="{aa3c5121-dab2-40e2-81ca-7ea25febc110}" # Firefox for Android
EXT_fa_tgtApp_minVersion="10.0"
EXT_fa_tgtApp_maxVersion="32.0"

EXT_fm_tgtApp_id="{a23983c0-fd0e-11dc-95ff-0800200c9a66}" # Mobile Firefox
EXT_fm_tgtApp_minVersion="10.0"
EXT_fm_tgtApp_maxVersion="31.0"

EXT_sm_tgtApp_id="{92650c4d-4b8e-4d2a-b7eb-24ecf4f6b63a}" # SeaMonkey
EXT_sm_tgtApp_minVersion="2.0"
EXT_sm_tgtApp_maxVersion="2.29"

EXT_tb_tgtApp_id="{3550f703-e582-4d05-9a08-453d09bdfdc6}" # Thunderbird
EXT_tb_tgtApp_minVersion="10.0"
EXT_tb_tgtApp_maxVersion="32.0"



MINIFIER="java -jar ../more/yuicompressor-2.4.8.jar --type"



mkdir -p src
cd src



mkdir -p content/
mkdir -p locale/pt-BR/
mkdir -p locale/en-US/
mkdir -p skin/



# <http://developer.mozilla.org/en-US/Add-ons/Extension_etiquette>
# <http://developer.mozilla.org/en-US/Add-ons/Performance_best_practices_in_extensions>
# <http://developer.mozilla.org/en-US/Add-ons/Security_best_practices_in_extensions>
# <http://adblockplus.org/blog/web-pages-accessing-chrome-is-forbidden>
# <http://flagfox.wordpress.com/2014/01/19/writing-restartless-addons/>



# <http://developer.mozilla.org/en-US/docs/Chrome_Registration>
cat << EOT >| chrome.manifest
content   $EXT   content/
content   $EXT   content/          contentaccessible=yes
locale    $EXT   pt-BR             locale/pt-BR/
locale    $EXT   en-US             locale/en-US/
skin      $EXT   classic/1.0       skin/

style     chrome://global/content/customizeToolbar.xul                       chrome://$EXT/skin/skin.css

# Firefox
overlay   chrome://browser/content/browser.xul                               chrome://$EXT/content/firefox+seamonkey.xul   application=$EXT_ff_tgtApp_id
overlay   chrome://browser/content/browser.xul                               chrome://$EXT/content/firefox+seamonkey.xul   application=$EXT_fa_tgtApp_id
overlay   chrome://browser/content/browser.xul                               chrome://$EXT/content/firefox+seamonkey.xul   application=$EXT_fm_tgtApp_id

# SeaMonkey Browser
overlay   chrome://navigator/content/navigator.xul                           chrome://$EXT/content/firefox+seamonkey.xul   application=$EXT_sm_tgtApp_id

# SeaMonkey HTML Editor
#overlay   chrome://editor/content/editor.xul                                 chrome://$EXT/content/firefox+seamonkey.xul   application=$EXT_sm_tgtApp_id

# Seamonkey Message Composer
#overlay   chrome://messenger/content/messengercompose/messengercompose.xul   chrome://$EXT/content/firefox+seamonkey.xul   application=$EXT_sm_tgtApp_id

# Thunderbird Message Composer
#overlay   chrome://messenger/content/messengercompose/messengercompose.xul   chrome://$EXT/content/thunderbird.xul         application=$EXT_tb_tgtApp_id

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
    <em:bootstrap   >true</em:bootstrap>

    <!-- Firefox -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_ff_tgtApp_id</em:id>
        <em:minVersion >$EXT_ff_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_ff_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>

    <!-- Firefox for Android -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_fa_tgtApp_id</em:id>
        <em:minVersion >$EXT_fa_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_fa_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>

    <!-- Mobile Firefox -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_fm_tgtApp_id</em:id>
        <em:minVersion >$EXT_fm_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_fm_tgtApp_maxVersion</em:maxVersion>
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

<!--
    <!-- Thunderbird -->
    <em:targetApplication>
      <Description>
        <em:id         >$EXT_tb_tgtApp_id</em:id>
        <em:minVersion >$EXT_tb_tgtApp_minVersion</em:minVersion>
        <em:maxVersion >$EXT_tb_tgtApp_maxVersion</em:maxVersion>
      </Description>
    </em:targetApplication>
-->

  </Description>

</RDF>
EOT



# <http://developer.mozilla.org/en-US/docs/Extensions/bootstrap.js>
cat << EOT >| bootstrap.js

// <http://www.oxymoronical.com/blog/2011/01/Playing-with-windows-in-restartless-bootstrapped-extensions>

const Cc = Components.classes;
const Ci = Components.interfaces;

var WindowListener =
{

  setupBrowserUI : function(window)
  {
    let document = window.document;
    // Take any steps to add UI or anything to the browser window
    // document.getElementById() etc. will work here
  },

  tearDownBrowserUI : function(window)
  {
    let document = window.document;
    // Take any steps to remove UI or anything from the browser window
    // document.getElementById() etc. will work here
  },

  onOpenWindow : function(xulWindow)
  // nsIWindowMediatorListener functions
  {
    // A new window has opened
    let domWindow = xulWindow.QueryInterface(Ci.nsIInterfaceRequestor).getInterface(Ci.nsIDOMWindow);
    // Wait for it to finish loading
    domWindow.addEventListener
    (
      'load',
      function listener()
      {
        domWindow.removeEventListener('load', listener, false);
        // If this is a browser window then setup its UI
        if ( domWindow.document.documentElement.getAttribute('windowtype') == 'navigator:browser' ) WindowListener.setupBrowserUI(domWindow);
      },
      false
    );
  },

  onCloseWindow : function(xulWindow)
  {
  },

  onWindowTitleChange : function(xulWindow, newTitle)
  {
  }

}

function startup(data, reason)
{
  // <summary>
  // Bootstrap data structure <http://developer.mozilla.org/en-US/docs/Extensions/Bootstrapped_extensions#Bootstrap_data>
  // - string id
  // - string version
  // - nsIFile installPath
  // - nsIURI resourceURI
  //
  // Reason types:
  // - APP_STARTUP
  // - ADDON_ENABLE
  // - ADDON_INSTALL
  // - ADDON_UPGRADE
  // - ADDON_DOWNGRADE
  // </summary>
  let wm = Cc['@mozilla.org/appshell/window-mediator;1'].getService(Ci.nsIWindowMediator);

  // Get the list of browser windows already open
  let windows = wm.getEnumerator('navigator:browser');
  while (windows.hasMoreElements())
  {
    let domWindow = windows.getNext().QueryInterface(Ci.nsIDOMWindow);
    WindowListener.setupBrowserUI(domWindow);
  }

  // Wait for any new browser windows to open
  wm.addListener(WindowListener);
}

function shutdown(data, reason)
{
  // <summary>
  // Bootstrap data structure <http://developer.mozilla.org/en-US/docs/Extensions/Bootstrapped_extensions#Bootstrap_data>
  // - string id
  // - string version
  // - nsIFile installPath
  // - nsIURI resourceURI
  //
  // Reason types:
  // - APP_SHUTDOWN
  // - ADDON_DISABLE
  // - ADDON_UNINSTALL
  // - ADDON_UPGRADE
  // - ADDON_DOWNGRADE
  // </summary>
  // When the application is shutting down we normally don't have to clean up any UI changes made
  if (reason == APP_SHUTDOWN) return;

  let wm = Cc['@mozilla.org/appshell/window-mediator;1'].getService(Ci.nsIWindowMediator);

  // Get the list of browser windows already open
  let windows = wm.getEnumerator('navigator:browser');
  while (windows.hasMoreElements())
  {
    let domWindow = windows.getNext().QueryInterface(Ci.nsIDOMWindow);
    WindowListener.tearDownBrowserUI(domWindow);
  }

  // Stop listening for any new browser windows to open
  wm.removeListener(WindowListener);
}

function install(data, reason)
{
  // <summary>
  // Bootstrap data structure <http://developer.mozilla.org/en-US/docs/Extensions/Bootstrapped_extensions#Bootstrap_data>
  // - string id
  // - string version
  // - nsIFile installPath
  // - nsIURI resourceURI
  //
  // Reason types:
  // - ADDON_INSTALL
  // - ADDON_UPGRADE
  // - ADDON_DOWNGRADE
  // </summary>
}

function uninstall(data, reason)
{
  // <summary>
  // Bootstrap data structure <http://developer.mozilla.org/en-US/docs/Extensions/Bootstrapped_extensions#Bootstrap_data>
  // - string id
  // - string version
  // - nsIFile installPath
  // - nsIURI resourceURI
  //
  // Reason types:
  // - ADDON_UNINSTALL
  // - ADDON_UPGRADE
  // - ADDON_DOWNGRADE
  // </summary>
}

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

    <menu id="$EXT" label="$EXT_name" insertafter="context-selectall" class="menu-iconic" onpopupshowing="$EXT.onPopupShowing()">
      <menupopup>

        <menu id="$EXT-03">
          <menupopup>
            <menuitem id="$EXT-03.1" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-03.2" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-03.3" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-03.4" oncommand="$EXT.run(this)" />
         <!--menuitem id="$EXT-03.5" oncommand="$EXT.run(this)" /-->
            <menuitem id="$EXT-03.6" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-03.7" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-03.8" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-03.9" oncommand="$EXT.run(this)" />
          </menupopup>
        </menu>

        <menu id="$EXT-11">
          <menupopup>
            <menuitem id="$EXT-11.1" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-11.2" oncommand="$EXT.run(this)" />
         <!--menuitem id="$EXT-11.3" oncommand="$EXT.run(this)" /-->
            <menuitem id="$EXT-11.4" oncommand="$EXT.run(this)" />
         <!--menuitem id="$EXT-11.5" oncommand="$EXT.run(this)" /-->
            <menuitem id="$EXT-11.6" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-11.7" oncommand="$EXT.run(this)" />
            <menuitem id="$EXT-11.8" oncommand="$EXT.run(this)" />
         <!--menuitem id="$EXT-11.9" oncommand="$EXT.run(this)" /-->
          </menupopup>
        </menu>

        <menuseparator/>

        <menuitem id="$EXT-00" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-01" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-02" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-38" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-39" oncommand="$EXT.run(this)" />

        <menuseparator/>

        <menuitem id="$EXT-28" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-29" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-30" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-31" oncommand="$EXT.run(this)" />

        <menuseparator/>

        <menuitem id="$EXT-17" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-18" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-19" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-20" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-21" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-37" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-22" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-23" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-24" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-25" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-26" oncommand="$EXT.run(this)" />

        <menuseparator/>

        <menuitem id="$EXT-32" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-33" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-34" oncommand="$EXT.run(this)" />
        <menuitem id="$EXT-36" oncommand="$EXT.run(this)" />

      </menupopup>
    </menu>

  </popup>

</overlay>
EOT
done



cat << EOT >| ../more/engine.js

if (typeof $EXT == 'undefined') var $EXT = {}; // $EXT_name namespace

// Controls the browser overlay for the extension
$EXT =
{



  \$ : function(id)
  {
    return document.getElementById(id);
  },



  onPopupShowing : function()
  {
    var strings = this.\$('$EXT-string-bundle');
    var arr1    = Array.prototype.slice.call(this.\$('$EXT').getElementsByTagName('menuitem')); // <http://stackoverflow.com/a/222847>
    var arr2    = Array.prototype.slice.call(this.\$('$EXT').getElementsByTagName('menu'    ));
    for (var i in arr1) arr1[i].label = strings.getString(arr1[i].id) + ' (' + this.change(arr1[i].id.split('-')[1],strings.getString('$EXT-exemplo')) + ')';
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
    return str.replace( /[^\u0000-\u007E]/g, function(a) { return $EXT.diacriticsMap[a] || a } );
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
        function(\$0, \$1, \$2) { return $EXT.reverse(\$2) + \$1 } // reverse the combining marks so they will end up in the same order later on (after another round of reversing)
      )
      .replace(regexSurrogatePair, '\$2\$1'); // Swap high and low surrogates so the low surrogates go first

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
      '03.5' : 'com serifa',
      '03.6' : 'com serifa negrito',
      '03.7' : 'com serifa italico',
      '03.8' : 'com serifa negrito italico',
      '03.9' : 'fullwidth',

      '11'   : 'grego',
      '11.1' : 'sem serifa',
      '11.2' : 'sem serifa negrito',
      '11.3' : 'sem serifa italico',
      '11.4' : 'sem serifa negrito italico',
      '11.5' : 'com serifa',
      '11.6' : 'com serifa negrito',
      '11.7' : 'com serifa italico',
      '11.8' : 'com serifa negrito italico',
      '11.9' : 'fullwidth',

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

    var strings      = this.\$('$EXT-string-bundle');

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

//    alert(strings.getString('$EXT-naoeditavel'));

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

window.addEventListener('load', function(e){ $EXT.onLoad(e); }, false);

EOT



cat << EOT >| locale/pt-BR/translations.properties

$EXT-00   = Maiúsculo
$EXT-01   = Minúsculo
$EXT-02   = Capital
$EXT-38   = Invertido
$EXT-39   = Trocar Caixa

$EXT-28   = Sobrelinhado
$EXT-29   = Sublinhado
$EXT-30   = Sublinhado Duplo
$EXT-31   = Tachado

$EXT-03   = Latino
$EXT-03.1 = Sem Serifa
$EXT-03.2 = Sem Serifa Negrito
$EXT-03.3 = Sem Serifa Itálico
$EXT-03.4 = Sem Serifa Negrito Itálico
$EXT-03.5 = Com Serifa
$EXT-03.6 = Com Serifa Negrito
$EXT-03.7 = Com Serifa Itálico
$EXT-03.8 = Com Serifa Negrito Itálico
$EXT-03.9 = Largura Completa

$EXT-11   = Grego
$EXT-11.1 = Sem Serifa
$EXT-11.2 = Sem Serifa Negrito
$EXT-11.3 = Sem Serifa Itálico
$EXT-11.4 = Sem Serifa Negrito Itálico
$EXT-11.5 = Com Serifa
$EXT-11.6 = Com Serifa Negrito
$EXT-11.7 = Com Serifa Itálico
$EXT-11.8 = Com Serifa Negrito Itálico
$EXT-11.9 = Largura Completa

$EXT-17   = Gótico
$EXT-18   = Gótico Negrito
$EXT-19   = Script
$EXT-20   = Script Negrito
$EXT-21   = Virado
$EXT-37   = Virado Invertido
$EXT-22   = Duplo
$EXT-23   = Monoespaçada
$EXT-24   = Superescrito
$EXT-25   = Subscrito
$EXT-26   = Versalete

$EXT-32   = Braille Padrão
$EXT-33   = Circulado
$EXT-34   = Entre Parênteses
$EXT-36   = Leet Básico

$EXT-exemplo     = Exemplo
$EXT-naoeditavel = Selecione texto em algum campo editável.

EOT



cat << EOT >| locale/en-US/translations.properties

$EXT-00   = Upper Case
$EXT-01   = Lower Case
$EXT-02   = Capital
$EXT-38   = Reversed
$EXT-39   = Swap Case

$EXT-28   = Overlined
$EXT-29   = Underlined
$EXT-30   = Double Underlined
$EXT-31   = Strikeout

$EXT-03   = Latin
$EXT-03.1 = Sans Serif
$EXT-03.2 = Sans Serif Bold
$EXT-03.3 = Sans Serif Italic
$EXT-03.4 = Sans Serif Bold Italic
$EXT-03.5 = With Serif
$EXT-03.6 = With Serif Bold
$EXT-03.7 = With Serif Italic
$EXT-03.8 = With Serif Bold Italic
$EXT-03.9 = Fullwidth

$EXT-11   = Greek
$EXT-11.1 = Sans Serif
$EXT-11.2 = Sans Serif Bold
$EXT-11.3 = Sans Serif Italic
$EXT-11.4 = Sans Serif Bold Italic
$EXT-11.5 = With Serif
$EXT-11.6 = With Serif Bold
$EXT-11.7 = With Serif Italic
$EXT-11.8 = With Serif Bold Italic
$EXT-11.9 = Fullwidth

$EXT-17   = Fraktur
$EXT-18   = Bold Fraktur
$EXT-19   = Script
$EXT-20   = Bold Script
$EXT-21   = Turned
$EXT-37   = Reverse Turned
$EXT-22   = Double-Struck
$EXT-23   = Monospace
$EXT-24   = Superscript
$EXT-25   = Subscript
$EXT-26   = Small Caps

$EXT-32   = Standard Braille
$EXT-33   = Circled
$EXT-34   = Parenthesized
$EXT-36   = Basic Leet

$EXT-exemplo     = Example
$EXT-naoeditavel = Select text in some editable field.

EOT



cat << EOT >| skin/skin.css

#$EXT
{
  list-style-image: URL("chrome://$EXT/skin/icon-16x16.png");
}

EOT



# por enquanto, os campos índice 1 e 2 do mapa de caracteres não estão sendo usados
cat ../more/charmap.json | sed -r "s/(: *\[ *'[^']+') *, *'[^]]*]/\1 ]/g" >| ../more/charmap0.json

echo

for f in engine.js charmap0.json
do
  cp -a ../more/$f content/$f
# cat ../more/$f | $MINIFIER js >| content/$f
# ft=%\'6d
# s1=$(stat -c %s ../more/$f)
# s2=$(stat -c %s content/$f)
# df=$(bc<<<"scale=9;100*(1-$s2/$s1)" | tr . ,)
# export LC_NUMERIC=
# echo -e "$f:\t$(printf $ft $s1) -> $(printf $ft $s2) ($(printf '%6.3f' $df)% menor)"
done

mv content/charmap0.json content/charmap.json
rm ../more/charmap0.json



rm      ../extension/$EXT_name-$EXT_major*
zip -qr ../extension/$EXT_name-$EXT_version.xpi *
ln -fs               $EXT_name-$EXT_version.xpi ../extension/$EXT_name.xpi

ln -nfs ../.thunderbird $HOME/.mozilla/thunderbird
for app in firefox seamonkey thunderbird
do
  extdir=$HOME/.mozilla/$app/devel/extensions
  mkdir -p                                 $extdir/
  [ "$EXT_id" ] && rm $extdir/$EXT_id*
# [ -e $extdir/$EXT_id ] || echo $PWD/ >|  $extdir/$EXT_id
# ln -fs "$PWD/../extension/$EXT_name.xpi" $extdir/$EXT_id.xpi
  cp -aL       ../extension/$EXT_name.xpi  $extdir/$EXT_id.xpi
done



f=$EXT_name-$EXT_version.xpi
echo -e "\n$f: $(printf $ft $(stat -c %s ../extension/$f))\n"



# EOF
