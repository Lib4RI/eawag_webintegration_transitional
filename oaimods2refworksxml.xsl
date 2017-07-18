<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Copyright (c) 2017 d-r-p <d-r-p@users.noreply.github.com>
 -
 - Permission to use, copy, modify, and distribute this software for any
 - purpose with or without fee is hereby granted, provided that the above
 - copyright notice and this permission notice appear in all copies.
 -
 - THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 - WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 - MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 - ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 - WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 - ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 - OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-->

<!--
  IMPORTANT NOTICES:
    - [@TODO] THIS XSL IS DEFINITELY NOT IDEAL, NOR STATE-OF-THE-ART!!!
      ACTUALLY, IT IS QUITE OBVIOUS HOW IT SHOULD BE MODIFIED. DUE TO TIME 
      CONSTRAINTS, THIS WILL BE DONE AT A LATER STAGE. MEANWHILE, WE USE THIS...
    - TAKE CARE WHEN MODIFYING THIS FILE, AS IT CONTAINS UTF-8 CHARACTERS.
      SOME EDITORS (E.G. XEMACS) HAVE TROUBLE WITH IT...
    - UPON REQUEST, ONLY THE NUMERICAL PART OF THE IDS ARE GIVEN IN THE
      CORRESPONDING TAG, SO YOU WILL HAVE TO PLACE ALL ENTRIES IN THE SAME
      NAMESPACE!!!
-->

<!DOCTYPE xsl:stylesheet [
   <!ENTITY nbsp "&amp;nbsp;">
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                exclude-result-prefixes="oai mods">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template name="getafterlastcolon">
    <xsl:param name="str"/>
    <xsl:choose>
      <xsl:when test="contains($str, ':')">
        <xsl:call-template name="getafterlastcolon">
          <xsl:with-param name="str" select="substring-after($str, ':')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mki-parsename">
    <xsl:param name="str"/>
    <xsl:param name="pos"/>
    <xsl:param name="gobblelc"/>
    <xsl:variable name="n" select="substring($str, 1, 1)"/>
    <xsl:variable name="rstr" select="substring($str, 2)"/>
    <xsl:if test="not($n = '')">
      <xsl:choose>
        <xsl:when test="translate($n, 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞĀĂĄĆĈĊČĎĐĒĔĖĘĚĜĞĠĢĤĦĨĪĬĮİĲĴĶĹĻĽĿŁŃŅŇŊŌŎŐŒŔŖŘŚŜŞŠŢŤŦŨŪŬŮŰŲŴŶŸŹŻŽƁƂƄƆƇƉƊƋƎƏƐƑƓƔƖƗƘƜƝƟƠƢƤƦƧƩƬƮƯƱƲƳƵƷƸƼǄǇǊǍǏǑǓǕǗǙǛǞǠǢǤǦǨǪǬǮǱǴǶǷǸǺǼǾȀȂȄȆȈȊȌȎȐȒȔȖȘȚȜȞȠȢȤȦȨȪȬȮȰȲȺȻȽȾɁɃɄɅɆɈɊɌɎͰͲͶͿΆΈΉΊΌΎΏΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫϏϒϓϔϘϚϜϞϠϢϤϦϨϪϬϮϴϷϹϺϽϾϿЀЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯѠѢѤѦѨѪѬѮѰѲѴѶѸѺѼѾҀҊҌҎҐҒҔҖҘҚҜҞҠҢҤҦҨҪҬҮҰҲҴҶҸҺҼҾӀӁӃӅӇӉӋӍӐӒӔӖӘӚӜӞӠӢӤӦӨӪӬӮӰӲӴӶӸӺӼӾԀԂԄԆԈԊԌԎԐԒԔԖԘԚԜԞԠԢԤԦԨԪԬԮԱԲԳԴԵԶԷԸԹԺԻԼԽԾԿՀՁՂՃՄՅՆՇՈՉՊՋՌՍՎՏՐՑՒՓՔՕՖႠႡႢႣႤႥႦႧႨႩႪႫႬႭႮႯႰႱႲႳႴႵႶႷႸႹႺႻႼႽႾႿჀჁჂჃჄჅჇჍᎠᎡᎢᎣᎤᎥᎦᎧᎨᎩᎪᎫᎬᎭᎮᎯᎰᎱᎲᎳᎴᎵᎶᎷᎸᎹᎺᎻᎼᎽᎾᎿᏀᏁᏂᏃᏄᏅᏆᏇᏈᏉᏊᏋᏌᏍᏎᏏᏐᏑᏒᏓᏔᏕᏖᏗᏘᏙᏚᏛᏜᏝᏞᏟᏠᏡᏢᏣᏤᏥᏦᏧᏨᏩᏪᏫᏬᏭᏮᏯᏰᏱᏲᏳᏴᏵḀḂḄḆḈḊḌḎḐḒḔḖḘḚḜḞḠḢḤḦḨḪḬḮḰḲḴḶḸḺḼḾṀṂṄṆṈṊṌṎṐṒṔṖṘṚṜṞṠṢṤṦṨṪṬṮṰṲṴṶṸṺṼṾẀẂẄẆẈẊẌẎẐẒẔẞẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼẾỀỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỲỴỶỸỺỼỾἈἉἊἋἌἍἎἏἘἙἚἛἜἝἨἩἪἫἬἭἮἯἸἹἺἻἼἽἾἿὈὉὊὋὌὍὙὛὝὟὨὩὪὫὬὭὮὯᾸᾹᾺΆῈΈῊΉῘῙῚΊῨῩῪΎῬῸΌῺΏℂℇℋℌℍℐℑℒℕℙℚℛℜℝℤΩℨKÅℬℭℰℱℲℳℾℿⅅↃⰀⰁⰂⰃⰄⰅⰆⰇⰈⰉⰊⰋⰌⰍⰎⰏⰐⰑⰒⰓⰔⰕⰖⰗⰘⰙⰚⰛⰜⰝⰞⰟⰠⰡⰢⰣⰤⰥⰦⰧⰨⰩⰪⰫⰬⰭⰮⱠⱢⱣⱤⱧⱩⱫⱭⱮⱯⱰⱲⱵⱾⱿⲀⲂⲄⲆⲈⲊⲌⲎⲐⲒⲔⲖⲘⲚⲜⲞⲠⲢⲤⲦⲨⲪⲬⲮⲰⲲⲴⲶⲸⲺⲼⲾⳀⳂⳄⳆⳈⳊⳌⳎⳐⳒⳔⳖⳘⳚⳜⳞⳠⳢⳫⳭⳲꙀꙂꙄꙆꙈꙊꙌꙎꙐꙒꙔꙖꙘꙚꙜꙞꙠꙢꙤꙦꙨꙪꙬꚀꚂꚄꚆꚈꚊꚌꚎꚐꚒꚔꚖꚘꚚꜢꜤꜦꜨꜪꜬꜮꜲꜴꜶꜸꜺꜼꜾꝀꝂꝄꝆꝈꝊꝌꝎꝐꝒꝔꝖꝘꝚꝜꝞꝠꝢꝤꝦꝨꝪꝬꝮꝹꝻꝽꝾꞀꞂꞄꞆꞋꞍꞐꞒꞖꞘꞚꞜꞞꞠꞢꞤꞦꞨꞪꞫꞬꞭꞮꞰꞱꞲꞳꞴꞶＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ𐐀𐐁𐐂𐐃𐐄𐐅𐐆𐐇𐐈𐐉𐐊𐐋𐐌𐐍𐐎𐐏𐐐𐐑𐐒𐐓𐐔𐐕𐐖𐐗𐐘𐐙𐐚𐐛𐐜𐐝𐐞𐐟𐐠𐐡𐐢𐐣𐐤𐐥𐐦𐐧𐒰𐒱𐒲𐒳𐒴𐒵𐒶𐒷𐒸𐒹𐒺𐒻𐒼𐒽𐒾𐒿𐓀𐓁𐓂𐓃𐓄𐓅𐓆𐓇𐓈𐓉𐓊𐓋𐓌𐓍𐓎𐓏𐓐𐓑𐓒𐓓𐲀𐲁𐲂𐲃𐲄𐲅𐲆𐲇𐲈𐲉𐲊𐲋𐲌𐲍𐲎𐲏𐲐𐲑𐲒𐲓𐲔𐲕𐲖𐲗𐲘𐲙𐲚𐲛𐲜𐲝𐲞𐲟𐲠𐲡𐲢𐲣𐲤𐲥𐲦𐲧𐲨𐲩𐲪𐲫𐲬𐲭𐲮𐲯𐲰𐲱𐲲𑢠𑢡𑢢𑢣𑢤𑢥𑢦𑢧𑢨𑢩𑢪𑢫𑢬𑢭𑢮𑢯𑢰𑢱𑢲𑢳𑢴𑢵𑢶𑢷𑢸𑢹𑢺𑢻𑢼𑢽𑢾𑢿𝐀𝐁𝐂𝐃𝐄𝐅𝐆𝐇𝐈𝐉𝐊𝐋𝐌𝐍𝐎𝐏𝐐𝐑𝐒𝐓𝐔𝐕𝐖𝐗𝐘𝐙𝐴𝐵𝐶𝐷𝐸𝐹𝐺𝐻𝐼𝐽𝐾𝐿𝑀𝑁𝑂𝑃𝑄𝑅𝑆𝑇𝑈𝑉𝑊𝑋𝑌𝑍𝑨𝑩𝑪𝑫𝑬𝑭𝑮𝑯𝑰𝑱𝑲𝑳𝑴𝑵𝑶𝑷𝑸𝑹𝑺𝑻𝑼𝑽𝑾𝑿𝒀𝒁𝒜𝒞𝒟𝒢𝒥𝒦𝒩𝒪𝒫𝒬𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵𝓐𝓑𝓒𝓓𝓔𝓕𝓖𝓗𝓘𝓙𝓚𝓛𝓜𝓝𝓞𝓟𝓠𝓡𝓢𝓣𝓤𝓥𝓦𝓧𝓨𝓩𝔄𝔅𝔇𝔈𝔉𝔊𝔍𝔎𝔏𝔐𝔑𝔒𝔓𝔔𝔖𝔗𝔘𝔙𝔚𝔛𝔜𝔸𝔹𝔻𝔼𝔽𝔾𝕀𝕁𝕂𝕃𝕄𝕆𝕊𝕋𝕌𝕍𝕎𝕏𝕐𝕬𝕭𝕮𝕯𝕰𝕱𝕲𝕳𝕴𝕵𝕶𝕷𝕸𝕹𝕺𝕻𝕼𝕽𝕾𝕿𝖀𝖁𝖂𝖃𝖄𝖅𝖠𝖡𝖢𝖣𝖤𝖥𝖦𝖧𝖨𝖩𝖪𝖫𝖬𝖭𝖮𝖯𝖰𝖱𝖲𝖳𝖴𝖵𝖶𝖷𝖸𝖹𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭𝘈𝘉𝘊𝘋𝘌𝘍𝘎𝘏𝘐𝘑𝘒𝘓𝘔𝘕𝘖𝘗𝘘𝘙𝘚𝘛𝘜𝘝𝘞𝘟𝘠𝘡𝘼𝘽𝘾𝘿𝙀𝙁𝙂𝙃𝙄𝙅𝙆𝙇𝙈𝙉𝙊𝙋𝙌𝙍𝙎𝙏𝙐𝙑𝙒𝙓𝙔𝙕𝙰𝙱𝙲𝙳𝙴𝙵𝙶𝙷𝙸𝙹𝙺𝙻𝙼𝙽𝙾𝙿𝚀𝚁𝚂𝚃𝚄𝚅𝚆𝚇𝚈𝚉𝚨𝚩𝚪𝚫𝚬𝚭𝚮𝚯𝚰𝚱𝚲𝚳𝚴𝚵𝚶𝚷𝚸𝚹𝚺𝚻𝚼𝚽𝚾𝚿𝛀𝛢𝛣𝛤𝛥𝛦𝛧𝛨𝛩𝛪𝛫𝛬𝛭𝛮𝛯𝛰𝛱𝛲𝛳𝛴𝛵𝛶𝛷𝛸𝛹𝛺𝜜𝜝𝜞𝜟𝜠𝜡𝜢𝜣𝜤𝜥𝜦𝜧𝜨𝜩𝜪𝜫𝜬𝜭𝜮𝜯𝜰𝜱𝜲𝜳𝜴𝝖𝝗𝝘𝝙𝝚𝝛𝝜𝝝𝝞𝝟𝝠𝝡𝝢𝝣𝝤𝝥𝝦𝝧𝝨𝝩𝝪𝝫𝝬𝝭𝝮𝞐𝞑𝞒𝞓𝞔𝞕𝞖𝞗𝞘𝞙𝞚𝞛𝞜𝞝𝞞𝞟𝞠𝞡𝞢𝞣𝞤𝞥𝞦𝞧𝞨𝟊𞤀𞤁𞤂𞤃𞤄𞤅𞤆𞤇𞤈𞤉𞤊𞤋𞤌𞤍𞤎𞤏𞤐𞤑𞤒𞤓𞤔𞤕𞤖𞤗𞤘𞤙𞤚𞤛𞤜𞤝𞤞𞤟𞤠𞤡ǅǈǋǲᾈᾉᾊᾋᾌᾍᾎᾏᾘᾙᾚᾛᾜᾝᾞᾟᾨᾩᾪᾫᾬᾭᾮᾯᾼῌῼ', '') = ''">
          <xsl:value-of select="$n"/><xsl:text>.</xsl:text>
          <xsl:call-template name="mki-parsename">
            <xsl:with-param name="str" select="$rstr"/>
            <xsl:with-param name="pos" select="$pos + 1"/>
            <xsl:with-param name="gobblelc" select="true()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="translate($n, 'abcdefghijklmnopqrstuvwxyzµßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿāăąćĉċčďđēĕėęěĝğġģĥħĩīĭįıĳĵķĸĺļľŀłńņňŉŋōŏőœŕŗřśŝşšţťŧũūŭůűųŵŷźżžſƀƃƅƈƌƍƒƕƙƚƛƞơƣƥƨƪƫƭưƴƶƹƺƽƾƿǆǉǌǎǐǒǔǖǘǚǜǝǟǡǣǥǧǩǫǭǯǰǳǵǹǻǽǿȁȃȅȇȉȋȍȏȑȓȕȗșțȝȟȡȣȥȧȩȫȭȯȱȳȴȵȶȷȸȹȼȿɀɂɇɉɋɍɏɐɑɒɓɔɕɖɗɘəɚɛɜɝɞɟɠɡɢɣɤɥɦɧɨɩɪɫɬɭɮɯɰɱɲɳɴɵɶɷɸɹɺɻɼɽɾɿʀʁʂʃʄʅʆʇʈʉʊʋʌʍʎʏʐʑʒʓʕʖʗʘʙʚʛʜʝʞʟʠʡʢʣʤʥʦʧʨʩʪʫʬʭʮʯͱͳͷͻͼͽΐάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώϐϑϕϖϗϙϛϝϟϡϣϥϧϩϫϭϯϰϱϲϳϵϸϻϼабвгдежзийклмнопрстуфхцчшщъыьэюяѐёђѓєѕіїјљњћќѝўџѡѣѥѧѩѫѭѯѱѳѵѷѹѻѽѿҁҋҍҏґғҕҗҙқҝҟҡңҥҧҩҫҭүұҳҵҷҹһҽҿӂӄӆӈӊӌӎӏӑӓӕӗәӛӝӟӡӣӥӧөӫӭӯӱӳӵӷӹӻӽӿԁԃԅԇԉԋԍԏԑԓԕԗԙԛԝԟԡԣԥԧԩԫԭԯաբգդեզէըթժիլխծկհձղճմյնշոչպջռսվտրցւփքօֆևᏸᏹᏺᏻᏼᏽᲀᲁᲂᲃᲄᲅᲆᲇᲈᴀᴁᴂᴃᴄᴅᴆᴇᴈᴉᴊᴋᴌᴍᴎᴏᴐᴑᴒᴓᴔᴕᴖᴗᴘᴙᴚᴛᴜᴝᴞᴟᴠᴡᴢᴣᴤᴥᴦᴧᴨᴩᴪᴫᵫᵬᵭᵮᵯᵰᵱᵲᵳᵴᵵᵶᵷᵹᵺᵻᵼᵽᵾᵿᶀᶁᶂᶃᶄᶅᶆᶇᶈᶉᶊᶋᶌᶍᶎᶏᶐᶑᶒᶓᶔᶕᶖᶗᶘᶙᶚḁḃḅḇḉḋḍḏḑḓḕḗḙḛḝḟḡḣḥḧḩḫḭḯḱḳḵḷḹḻḽḿṁṃṅṇṉṋṍṏṑṓṕṗṙṛṝṟṡṣṥṧṩṫṭṯṱṳṵṷṹṻṽṿẁẃẅẇẉẋẍẏẑẓẕẖẗẘẙẚẛẜẝẟạảấầẩẫậắằẳẵặẹẻẽếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹỻỽỿἀἁἂἃἄἅἆἇἐἑἒἓἔἕἠἡἢἣἤἥἦἧἰἱἲἳἴἵἶἷὀὁὂὃὄὅὐὑὒὓὔὕὖὗὠὡὢὣὤὥὦὧὰάὲέὴήὶίὸόὺύὼώᾀᾁᾂᾃᾄᾅᾆᾇᾐᾑᾒᾓᾔᾕᾖᾗᾠᾡᾢᾣᾤᾥᾦᾧᾰᾱᾲᾳᾴᾶᾷιῂῃῄῆῇῐῑῒΐῖῗῠῡῢΰῤῥῦῧῲῳῴῶῷℊℎℏℓℯℴℹℼℽⅆⅇⅈⅉⅎↄⰰⰱⰲⰳⰴⰵⰶⰷⰸⰹⰺⰻⰼⰽⰾⰿⱀⱁⱂⱃⱄⱅⱆⱇⱈⱉⱊⱋⱌⱍⱎⱏⱐⱑⱒⱓⱔⱕⱖⱗⱘⱙⱚⱛⱜⱝⱞⱡⱥⱦⱨⱪⱬⱱⱳⱴⱶⱷⱸⱹⱺⱻⲁⲃⲅⲇⲉⲋⲍⲏⲑⲓⲕⲗⲙⲛⲝⲟⲡⲣⲥⲧⲩⲫⲭⲯⲱⲳⲵⲷⲹⲻⲽⲿⳁⳃⳅⳇⳉⳋⳍⳏⳑⳓⳕⳗⳙⳛⳝⳟⳡⳣⳤⳬⳮⳳⴀⴁⴂⴃⴄⴅⴆⴇⴈⴉⴊⴋⴌⴍⴎⴏⴐⴑⴒⴓⴔⴕⴖⴗⴘⴙⴚⴛⴜⴝⴞⴟⴠⴡⴢⴣⴤⴥⴧⴭꙁꙃꙅꙇꙉꙋꙍꙏꙑꙓꙕꙗꙙꙛꙝꙟꙡꙣꙥꙧꙩꙫꙭꚁꚃꚅꚇꚉꚋꚍꚏꚑꚓꚕꚗꚙꚛꜣꜥꜧꜩꜫꜭꜯꜰꜱꜳꜵꜷꜹꜻꜽꜿꝁꝃꝅꝇꝉꝋꝍꝏꝑꝓꝕꝗꝙꝛꝝꝟꝡꝣꝥꝧꝩꝫꝭꝯꝱꝲꝳꝴꝵꝶꝷꝸꝺꝼꝿꞁꞃꞅꞇꞌꞎꞑꞓꞔꞕꞗꞙꞛꞝꞟꞡꞣꞥꞧꞩꞵꞷꟺꬰꬱꬲꬳꬴꬵꬶꬷꬸꬹꬺꬻꬼꬽꬾꬿꭀꭁꭂꭃꭄꭅꭆꭇꭈꭉꭊꭋꭌꭍꭎꭏꭐꭑꭒꭓꭔꭕꭖꭗꭘꭙꭚꭠꭡꭢꭣꭤꭥꭰꭱꭲꭳꭴꭵꭶꭷꭸꭹꭺꭻꭼꭽꭾꭿꮀꮁꮂꮃꮄꮅꮆꮇꮈꮉꮊꮋꮌꮍꮎꮏꮐꮑꮒꮓꮔꮕꮖꮗꮘꮙꮚꮛꮜꮝꮞꮟꮠꮡꮢꮣꮤꮥꮦꮧꮨꮩꮪꮫꮬꮭꮮꮯꮰꮱꮲꮳꮴꮵꮶꮷꮸꮹꮺꮻꮼꮽꮾꮿﬀﬁﬂﬃﬄﬅﬆﬓﬔﬕﬖﬗａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ𐐨𐐩𐐪𐐫𐐬𐐭𐐮𐐯𐐰𐐱𐐲𐐳𐐴𐐵𐐶𐐷𐐸𐐹𐐺𐐻𐐼𐐽𐐾𐐿𐑀𐑁𐑂𐑃𐑄𐑅𐑆𐑇𐑈𐑉𐑊𐑋𐑌𐑍𐑎𐑏𐓘𐓙𐓚𐓛𐓜𐓝𐓞𐓟𐓠𐓡𐓢𐓣𐓤𐓥𐓦𐓧𐓨𐓩𐓪𐓫𐓬𐓭𐓮𐓯𐓰𐓱𐓲𐓳𐓴𐓵𐓶𐓷𐓸𐓹𐓺𐓻𐳀𐳁𐳂𐳃𐳄𐳅𐳆𐳇𐳈𐳉𐳊𐳋𐳌𐳍𐳎𐳏𐳐𐳑𐳒𐳓𐳔𐳕𐳖𐳗𐳘𐳙𐳚𐳛𐳜𐳝𐳞𐳟𐳠𐳡𐳢𐳣𐳤𐳥𐳦𐳧𐳨𐳩𐳪𐳫𐳬𐳭𐳮𐳯𐳰𐳱𐳲𑣀𑣁𑣂𑣃𑣄𑣅𑣆𑣇𑣈𑣉𑣊𑣋𑣌𑣍𑣎𑣏𑣐𑣑𑣒𑣓𑣔𑣕𑣖𑣗𑣘𑣙𑣚𑣛𑣜𑣝𑣞𑣟𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳𝑎𝑏𝑐𝑑𝑒𝑓𝑔𝑖𝑗𝑘𝑙𝑚𝑛𝑜𝑝𝑞𝑟𝑠𝑡𝑢𝑣𝑤𝑥𝑦𝑧𝒂𝒃𝒄𝒅𝒆𝒇𝒈𝒉𝒊𝒋𝒌𝒍𝒎𝒏𝒐𝒑𝒒𝒓𝒔𝒕𝒖𝒗𝒘𝒙𝒚𝒛𝒶𝒷𝒸𝒹𝒻𝒽𝒾𝒿𝓀𝓁𝓂𝓃𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏𝓪𝓫𝓬𝓭𝓮𝓯𝓰𝓱𝓲𝓳𝓴𝓵𝓶𝓷𝓸𝓹𝓺𝓻𝓼𝓽𝓾𝓿𝔀𝔁𝔂𝔃𝔞𝔟𝔠𝔡𝔢𝔣𝔤𝔥𝔦𝔧𝔨𝔩𝔪𝔫𝔬𝔭𝔮𝔯𝔰𝔱𝔲𝔳𝔴𝔵𝔶𝔷𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫𝖆𝖇𝖈𝖉𝖊𝖋𝖌𝖍𝖎𝖏𝖐𝖑𝖒𝖓𝖔𝖕𝖖𝖗𝖘𝖙𝖚𝖛𝖜𝖝𝖞𝖟𝖺𝖻𝖼𝖽𝖾𝖿𝗀𝗁𝗂𝗃𝗄𝗅𝗆𝗇𝗈𝗉𝗊𝗋𝗌𝗍𝗎𝗏𝗐𝗑𝗒𝗓𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇𝘢𝘣𝘤𝘥𝘦𝘧𝘨𝘩𝘪𝘫𝘬𝘭𝘮𝘯𝘰𝘱𝘲𝘳𝘴𝘵𝘶𝘷𝘸𝘹𝘺𝘻𝙖𝙗𝙘𝙙𝙚𝙛𝙜𝙝𝙞𝙟𝙠𝙡𝙢𝙣𝙤𝙥𝙦𝙧𝙨𝙩𝙪𝙫𝙬𝙭𝙮𝙯𝚊𝚋𝚌𝚍𝚎𝚏𝚐𝚑𝚒𝚓𝚔𝚕𝚖𝚗𝚘𝚙𝚚𝚛𝚜𝚝𝚞𝚟𝚠𝚡𝚢𝚣𝚤𝚥𝛂𝛃𝛄𝛅𝛆𝛇𝛈𝛉𝛊𝛋𝛌𝛍𝛎𝛏𝛐𝛑𝛒𝛓𝛔𝛕𝛖𝛗𝛘𝛙𝛚𝛜𝛝𝛞𝛟𝛠𝛡𝛼𝛽𝛾𝛿𝜀𝜁𝜂𝜃𝜄𝜅𝜆𝜇𝜈𝜉𝜊𝜋𝜌𝜍𝜎𝜏𝜐𝜑𝜒𝜓𝜔𝜖𝜗𝜘𝜙𝜚𝜛𝜶𝜷𝜸𝜹𝜺𝜻𝜼𝜽𝜾𝜿𝝀𝝁𝝂𝝃𝝄𝝅𝝆𝝇𝝈𝝉𝝊𝝋𝝌𝝍𝝎𝝐𝝑𝝒𝝓𝝔𝝕𝝰𝝱𝝲𝝳𝝴𝝵𝝶𝝷𝝸𝝹𝝺𝝻𝝼𝝽𝝾𝝿𝞀𝞁𝞂𝞃𝞄𝞅𝞆𝞇𝞈𝞊𝞋𝞌𝞍𝞎𝞏𝞪𝞫𝞬𝞭𝞮𝞯𝞰𝞱𝞲𝞳𝞴𝞵𝞶𝞷𝞸𝞹𝞺𝞻𝞼𝞽𝞾𝞿𝟀𝟁𝟂𝟄𝟅𝟆𝟇𝟈𝟉𝟋𞤢𞤣𞤤𞤥𞤦𞤧𞤨𞤩𞤪𞤫𞤬𞤭𞤮𞤯𞤰𞤱𞤲𞤳𞤴𞤵𞤶𞤷𞤸𞤹𞤺𞤻𞤼𞤽𞤾𞤿𞥀𞥁𞥂𞥃', '') = ''">
          <xsl:if test="not($gobblelc = true()) or $pos = 1"><xsl:value-of select="$n"/></xsl:if>
          <xsl:call-template name="mki-parsename">
            <xsl:with-param name="str" select="$rstr"/>
            <xsl:with-param name="pos" select="$pos + 1"/>
            <xsl:with-param name="gobblelc" select="$gobblelc"/>
          </xsl:call-template>
        </xsl:when>
	<xsl:when test="$n = '.'">
	  <xsl:text> </xsl:text>
          <xsl:call-template name="mki-parsename">
              <xsl:with-param name="str" select="$rstr"/>
            <xsl:with-param name="pos" select="$pos + 1"/>
            <xsl:with-param name="gobblelc" select="false()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$n"/>
          <xsl:call-template name="mki-parsename">
            <xsl:with-param name="str" select="$rstr"/>
            <xsl:with-param name="pos" select="$pos + 1"/>
            <xsl:with-param name="gobblelc" select="false()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="makeinitial">
    <xsl:param name="name"/>
    <xsl:call-template name="mki-parsename">
      <xsl:with-param name="str" select="$name"/>
      <xsl:with-param name="pos" select="1"/>
      <xsl:with-param name="gobblelc" select="false()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="str"/>
    <xsl:param name="txt"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($str, $txt)">
        <xsl:value-of select="substring-before($str, $txt)"/>
        <xsl:value-of select="$by"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="str" select="substring-after($str, $txt)"/>
          <xsl:with-param name="txt" select="$txt"/>
          <xsl:with-param name="by" select="$by"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="processgivenname">
    <xsl:param name="str"/>
    <xsl:variable name="initials">
      <xsl:for-each select="str:tokenize($str, ' ')">
        <xsl:call-template name="makeinitial"><xsl:with-param name="name" select="."/></xsl:call-template><xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="str" select="normalize-space($initials)"/>
      <xsl:with-param name="txt" select="' '"/>
      <xsl:with-param name="by" select="'&nbsp;'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="makea1fields">
    <xsl:param name="root"/>
    <xsl:param name="role"/>
    <xsl:for-each select="$root/mods:name[@type = 'personal' and mods:role/mods:roleTerm[@authority = 'marcrelator' and @type = 'text'] = $role]">
      <a1><xsl:value-of select="./mods:namePart[@type = 'family']"/><xsl:if test="not(./mods:namePart[@type = 'given'] = '')"><xsl:text>,&nbsp;</xsl:text><xsl:call-template name="processgivenname">
          <xsl:with-param name="str"><xsl:value-of select="./mods:namePart[@type = 'given']"/></xsl:with-param>
        </xsl:call-template></xsl:if></a1>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="removefinal">
    <xsl:param name="str"/>
    <xsl:param name="toremove"/>
    <xsl:choose>
      <xsl:when test="substring($str, string-length($str) - string-length($toremove) + 1) = $toremove">
        <xsl:value-of select="substring($str, 1, string-length($str) - string-length($toremove))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="geteditorlist">
    <xsl:param name="root"/>
    <xsl:variable name="editorlist">
      <xsl:call-template name="removefinal">
        <xsl:with-param name="str">
	  <xsl:for-each select="$root/mods:relatedItem[@type='host']/mods:name[@type = 'personal' and mods:role/mods:roleTerm[@authority = 'marcrelator' and @type = 'text'] = 'editor']"><xsl:value-of select="./mods:namePart[@type = 'family']"/><xsl:if test="not(./mods:namePart[@type = 'given'] = '')">,&nbsp;<xsl:call-template name="processgivenname"><xsl:with-param name="str"><xsl:value-of select="./mods:namePart[@type = 'given']"/></xsl:with-param></xsl:call-template></xsl:if>; </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="toremove" select="'; '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="not($editorlist = '')"><xsl:value-of select="$editorlist"/> (Ed<xsl:if test="contains($editorlist, ';')">s</xsl:if>.), </xsl:if>
  </xsl:template>

  <xsl:template name="makejffield-bookch-procpaper-confitem">
    <xsl:param name="root"/>
    <xsl:variable name="journalstring">
      <xsl:call-template name="removefinal">
        <xsl:with-param name="str">
          <xsl:call-template name="geteditorlist">
            <xsl:with-param name="root" select="$root"/>
          </xsl:call-template><xsl:value-of select="$root/mods:relatedItem[@type='host']/mods:titleInfo[not(@type)]/mods:title"/>
        </xsl:with-param>
        <xsl:with-param name="toremove" select="', '"/>
      </xsl:call-template>
    </xsl:variable>
    <jf><xsl:if test="not($journalstring = '')">In: <xsl:value-of select="$journalstring"/></xsl:if></jf>
  </xsl:template>

  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;?xml-stylesheet type="text/xsl" href="refworksxml2html.xsl"?&gt;
</xsl:text>
    <xsl:comment> NOTE: This RefWorks export was autogenerated from an OAI export. </xsl:comment>
    <xsl:variable name="timestamp" select="/oai:OAI-PMH/oai:ListRecords/@timestamp"/>
    <xsl:variable name="count" select="/oai:OAI-PMH/oai:ListRecords/@count"/>
    <refworks xmlns:refworks="www.refworks.com/xml/" timestamp="{$timestamp}" count="{$count}">
      <xsl:for-each select="/oai:OAI-PMH/oai:ListRecords/oai:record">
        <xsl:variable name="oaiid">
          <xsl:call-template name="getafterlastcolon">
            <xsl:with-param name="str" select="./oai:header/oai:identifier"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="doraid" select="translate($oaiid, '_', ':')"/>
        <xsl:variable name="doraidnumeric">
          <xsl:call-template name="getafterlastcolon">
            <xsl:with-param name="str" select="$doraid"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mods" select="./oai:metadata/mods:mods"/>
        <xsl:variable name="refid" select="$mods/mods:identifier[@type='local']"/>
        <xsl:variable name="genre" select="$mods/mods:genre[@authorityURI='info:eu-repo/semantics' and @valueURI]"/>
        <reference inMyList="undefined" owner="true" doraid="{$doraid}" refid="{$refid}" isShared="true" genre="{$genre}">
          <dl>https://www.dora.lib4ri.ch/eawag/islandora/object/<xsl:value-of select="$doraid"/></dl>
          <yr><xsl:value-of select="$mods/mods:originInfo/mods:dateIssued[@encoding='w3cdtf' and @keyDate='yes']"/></yr>
          <is><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:part/mods:detail[@type='issue']/mods:number"/></is>
          <xsl:choose>
            <xsl:when test="$genre = 'Book' or $genre = 'Edited Book' or $genre = 'Brochure' or $genre = 'Conference Proceedings'">
              <sp><xsl:value-of select="$mods/mods:physicalDescription/mods:extent[@unit = 'pages']"/><xsl:if test="not($mods/mods:physicalDescription/mods:extent[@unit = 'pages'] = '')">&nbsp;p</xsl:if></sp>
            </xsl:when>
            <xsl:when test="$genre = 'Report' or $genre = 'Scientific Report' or $genre = 'Bachelor Thesis' or $genre = 'Master Thesis' or $genre = 'Dissertation'">
              <sp><xsl:value-of select="$mods/mods:physicalDescription/mods:extent[@unit = 'page']"/><xsl:if test="not($mods/mods:physicalDescription/mods:extent[@unit = 'page'] = '')">&nbsp;p</xsl:if></sp>
            </xsl:when>
            <xsl:otherwise>
              <sp><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:part/mods:extent[@unit='page']/mods:start"/></sp>
            </xsl:otherwise>
          </xsl:choose>
          <doi><xsl:value-of select="$mods/mods:identifier[@type='doi']"/></doi>
          <t1><xsl:value-of select="$mods/mods:titleInfo/mods:title"/></t1>
          <xsl:choose>
            <xsl:when test="$genre = 'Edited Book' or $genre = 'Conference Proceedings'">
              <xsl:call-template name="makea1fields">
                <xsl:with-param name="root" select="$mods"/>
                <xsl:with-param name="role" select="'editor'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="makea1fields" select="$mods">
                <xsl:with-param name="root" select="$mods"/>
                <xsl:with-param name="role" select="'author'"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:for-each select="$mods/mods:subject/mods:topic">
            <k1><xsl:value-of select="."/></k1>
          </xsl:for-each>
          <ab><xsl:value-of select="$mods/mods:abstract"/></ab>
          <xsl:choose>
            <xsl:when test="$genre = 'Book' or $genre = 'Edited Book' or $genre = 'Brochure' or $genre = 'Report' or $genre = 'Scientific Report' or $genre = 'Bachelor Thesis' or $genre = 'Master Thesis' or $genre = 'Dissertation' or $genre = 'Conference Proceedings'">
              <vo><xsl:value-of select="$mods/mods:originInfo/mods:place/mods:placeTerm[@type='text']"/><xsl:if test="not($mods/mods:originInfo/mods:place/mods:placeTerm[@type='text'] = '') and not($mods/mods:originInfo/mods:publisher = '')">: </xsl:if><xsl:value-of select="$mods/mods:originInfo/mods:publisher"/></vo>
            </xsl:when>
            <xsl:when test="$genre = 'Book Chapter' or $genre = 'Proceedings Paper' or $genre = 'Conference Item'">
              <vo><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:originInfo/mods:place/mods:placeTerm[@type='text']"/><xsl:if test="not($mods/mods:relatedItem[@type='host']/mods:originInfo/mods:place/mods:placeTerm[@type='text'] = '') and not($mods/mods:relatedItem[@type='host']/mods:originInfo/mods:publisher = '')">: </xsl:if><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:originInfo/mods:publisher"/></vo>
            </xsl:when>
            <xsl:otherwise>
              <vo><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:part/mods:detail[@type='volume']/mods:number"/></vo>
            </xsl:otherwise>
          </xsl:choose>
          <sn><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:identifier[@type='issn']"/></sn>
          <xsl:choose>
            <xsl:when test="$genre = 'Book' or $genre = 'Edited Book' or $genre = 'Brochure' or $genre = 'Report' or $genre = 'Scientific Report' or $genre = 'Bachelor Thesis' or $genre = 'Master Thesis' or $genre = 'Dissertation' or $genre = 'Conference Proceedings'"/>
            <xsl:when test="$genre = 'Book Chapter' or $genre = 'Proceedings Paper' or $genre = 'Conference Item'">
              <xsl:call-template name="makejffield-bookch-procpaper-confitem">
                <xsl:with-param name="root" select="$mods"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <jf><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:titleInfo[not(@type)]/mods:title"/></jf>
            </xsl:otherwise>
          </xsl:choose>
          <!-- N.B.: The following line assumes that all ids are within the same namespace!!! -->
          <id><xsl:value-of select="$doraidnumeric"/></id>
          <op><xsl:value-of select="$mods/mods:relatedItem[@type='host']/mods:part/mods:extent[@unit='page']/mods:end"/></op>
        </reference>
      </xsl:for-each>
    </refworks>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
