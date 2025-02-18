# base4096 for Godot 4.x

base4096 is an encoding scheme in the same vein as [base64](https://en.wikipedia.org/wiki/Base64) that seeks to minimize the amount of characters to represent data. 

This is a compression scheme for when logical character count matters more than physical bytes. This can be useful for apps that limit character count, such as Discord that caps at 2000 characters per message.

## Why?
I started experimenting with this while trying to find a way to transmit data similar to [Animal Crossing custom designs](https://nookipedia.com/wiki/Design) which are 32x32 images with 16 colors. (As well as some bonus metadata.) Animal Crossing does this using QR codes or an in-game browser. I am always a fan of avoiding servers for video game purposes, so an offline scheme was of interest to me. On Mac OS-like and mobile operating systems, the clipboard can be utilized for easy data transfer. QR codes are technically also possible, but the use case is overly complex and wasteful as far as data goes.

I initially wrote it in GDScript, did experimentation in Python, then reimplemented the code in GDScript rewritten for clarity.

When using text, a raw dump of the hex values would best case be 1024 characters, which is workable in some cases but not in others. Animal Crossing has a Pro Design format which allows four 32x32 images to be packed. One for the front, back, and the two sleeves of a shirt. This would require three messages if it was unencoded hex data. (1,024 * 4 = 4,096)

base4096 can compress this to 342 characters. This would allow for 5 images to be fit inside of one 2000 character message, up from 1.

This could also be utilized for other situations of small user created data to be shared.

## Godot Project

You can play around with the image code yourself, and also see a test program included alongside. This allows you to preview inputs/outputs of the encoding scheme.

Here are three custom designs you can try out, which are not the same as the screenshot. Paste it into the image input field and then press decode.
```
AAAAAAAAAAAAAAAAA㒭AAAAAAAAA∌䃟AAAAAAAAJ䃮㿯AAAAAAAA㓮䃡AAAAAAAAK䃮㳯AAAAAAAA≬䂯AAAAAAAAA㾵AAAAAAAЦ㮂AW㲺㤏AAAAм䃮䃬㩪䃮䃮䂏AAAK䃮䃮䃮䃮䃮䃮䂿AAA㣮䃮䃮䃮䃮䃮䃮㿿AAP䃮䃮䃮䃮䃮䃮䃏AAA㣮䃮䃮䃮䃮䃮䃮╭AAN䃮䃮䃮䃮䃮䃮䂟AAA╬䃮䃮䃮䃮䃮䃮㛯AAB䃮䃮䃮䃮䃮䃮䃢AAA`䃮䃮䃮䃮䃮䃮䀟AAA╬䃮䃮䃮䃮䃮䃮㟯AAA㿮䃮䃮䃮䃮䃮䃫AAAN䃮䃮䃮䃮䃮䃮䃣AAAь䃮䃮䃮䃮䃮䃮䃡AAA๭䃮䃮䃮䃮䃮䃮䃤AAA㿮䃮䃮䃮䃮䃮䃮䃡AAG䃮䃮䃮䃮䃮䃮䃮㳯AAP䃮䃮䃮䃮䃮䃮䃡AAAΦ䃮䃮䃮䃮䃮䃮㫯AAA≌䃮䃮䃮䃮䃮䃟AAAA≬䃮䃮䃮䃮䃮㗯AAAA๭䃮䃛㻮䃮䁟AAAAAอ㾁Aк䃃AAAAAAAAAAAAA≠╋㷡ऽ㴿㮊㲤㫂㱈㲤䃑х㒠㠔㰣㟫ธ∙㸑㑨㰎Σ㞈㜼फ㜀㢩㪽ॴ㝛㶞┩⊮㔃㘖㹅㫦㖳∙㜕䃓㛝㼭च㺏㱿㢟㐅㥺㓾㳫㗈㹋㚦㲐㡩฾䀍㑯㑰С㒲㝓㗘㗯㒾㫚㼈㶢㾲㓧╓㬻∇┱㒹㵽㚺㵪㪠㹯㢈╴०㢘㺠㫐ँ㰎㥿㓝╋㷞㩤^╉㠕䀸㥞䁗㕸㷘㓷㯙㫺㠆㖝⊐㩮㿻㢇㷟㻹㰚㬳㩪㠌㛝㶦㒝㣕㧦㟘㳼㓗㧘⋕㙍ऽ㰈㔎㮓⊮㴐㹯㦬㨡╦╜㭛㒂㿡๸㗳㝬⊃㟳㑨㞺≜㲃㓕㶙㝏㒜㽍㘽㶠㴧㗌㕕㴦㯒㙿㛈≎㼱㸱䂦㻤l㙚䀺㝨䂮㽴㖒㓖䁊๨㾷㤲㻓㮳㾦㜬䁸㚆㾓㟛㨱㟶㱨㣋㛟㐦㼵㡡㷻㫧⊕㙊㹵Ь䀣㬠㣲㙔㵅㦠㳕㩈㠄㨵㵢㳘㗳㕕㩌㵁㞴㴩⋴㽙㤛㨔㲟㟷㼚C⋙㻤㫬㷍㢶㦙㪾㭬䁕㹞㸫㰼㓵⋙㞘╨䂟㑸ต㨲㧁㿝㲧䃁㽂㵑㼵ॉ㸌㔹−㨃㔟㪃㽔१้㼘㽶㺧㴔㒿㱥๜㔄s㗌㯳㖺๛㒹䁶ङ㟻॓㡄㪻≾㧊㪟㺄䁵∾㹿㘓㚞㬼㬐㨏㖈㯲㠒㖹㚒F㑬㲘㺊䃬㔊㔦㫠㐡㶖㗥๛┢㸜㑾㒘㭽o㑁㹻㱡㥞㒷㽻㑡㛡㥂∤㬢क㛶㑨䃗㪾㺭㑟㵳㔯
```
```
䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮㻮䃮䃮䃮䃮䃮䃮䃮䃮䃮㺥㿮䃮䃮䃮䃮䃮䃮䃮䃮䃭㔪䃮䃮䃮䃮䃮䃮䃮䃮䃮䃦㧎䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䂗㫮䃜㿮䃮䃮䃮䃮䃮䃮䂤㕕㕄㐣㟮䃮䃮䃮䃮䃮㺅㔔㝔㡤॒㟮䃮䃮䃮䃮䃦㘣ृ㔵㜲㙒㛮䃮䃮䃮䃮㸳㠲॑㝒॓㔣䃮䃮䃮䃮䃦㙄㙆㔶㜲㝃㜭䃮䃮䃮䃮䃅㦮㘳त㤵㔲㛎䃮䃮䃮䃮䃮䃄㖙㕞㘴㤴㫮䃮䃮䃮䃮䃮㘦㲴㗤ป㾁䃮䃮䃮䃮䂔㜢㐢㐢㔢㐣㐣㣮䃮䃬㩓㕄㘲㐳㙕㥷㡕㝖㢾䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃪㺬䂹㶪㿋䃞䂭㮺㾺㷫㳮䂝㢝㥗㭪㝼㧮㚷㩜㡷㽽䃮㪚㮘㲘㦷㮧䃧㶊㾈㩻㪎䃮䃮䃮䃮䃮䃮䃮䃮䃮䃮䃨㪈㪈㪈㪈㪈㪈㪈㪈㪈㪈㨢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㐢㓚㺎㿲㕷㿊㱩䁱㝀㞮═㠏ॕ㥉㒶㷖㮧㮑ब㡺W㩯२㪪㒽㒡㾰㼡㚧䂹㛇䁖㿴㿮㔳㶠≑⊄㼰㢓㢀㽮㤔㶙ट㚉㐍㩤䃖㶟㜓㫓≟㓟㭴㠠㸶㽦㼊㟿㚹∇䃪Ν㮅㘛㢲㦻㳄㱏㻥㯡㗸㝩㶑㡷㹳㓟㾸Щ㠅㭸㩪䃌㓦ॺ\㼌㪦㟚≫㛅㞎㜃㡁㢜└╪㼽㛀и㛏㐳⊩㡵㠘㴵㫛㖖㕪⋜≙ค㧠㪤㺝㞣㞢㹜㛓䁊㩼㙄㠷㚙㥄㥚Μ㠤㯳⋕㣷㚙∏╩─⊴㖖㞅๰㦷㕰㾑㷝╮㣫㢍㠥㣇ฦॸ㹳㭘㯊㯵㢾㹦㥂яॅ㗡^㭖㥲़㜘㟧㖪㤸㵲㴘㦻㒜㝡㱰㓘㺚Q㠔㸯㫺㘧䃠㱵॒㝩㐦㑺㰃㿣㸉㤑㒸㪂㔞ङ㾊ष⋅ธ㫭㲐㻔㜏㩕㑇㺫㚧㬺㳂㿴╆㶧㟝㔊㪆㐋㩏㭙㧼㝅㞟䀧㺋㯸㥀㽁㴷㩚㔳㺥ย㻼㣤㡵㿧㢚㤳㷅㥐㥺㲖U㥺㡸㚁䃙๯㚆㰜㪓㝇㒹㮂㪶䂴䂿㟛≩㨄㙽㸣㔇╢㼅㢴㜔㢉㾁㪨㒣㱏㶡㬂≘䁕㞩㮅㛄㽓㪯㝦㰚㣐क़㩽ิ㲂ौ㑹≷㤲⋱䁶㓩㨨㳺㸢㭺ॹ㓅ऺ㩩㞊㡎䃥㽒≢㤷㙧㒽∇㰂㿓㸄Δ㤢㤓㢐㛠㕌О┊㪗㮆㚁㞛ย㷱䁟㡆╛㥦㞆㘬䀉㹛㧰㨧㑬㽂⋎┝
```
```
㔳㔳㔳㔳㔴㙄㙃㔳㔳㔳㔳㔳㔳㔳㙃≭A㑃㔳㔳㔳㔳㔳㔳㘿И㷌㺷E㙃㘳㘳㔳㔴㕀∫㺜㒳㩹㸯㘳㔳㔳㔳㔴∕㪼㥤㡛㸘㾯㑃㔳㔳㕃㗼㟇㧘㔢㕜㧋㳁ु㘳㕃㔿㺆㗓㪚㲪㲒㶸㫡㑃㔳㔴∦㢘㢩㮈㪈㮩㕹㒯㔳㔳㘕㻊㞉㮊䃮䂨㮚㚪㺟㘳㔴∨㺇㮙㯜㻎䂚㮚㟌㸲㔳㘖㝜㚩㮜㻍㾾㪸㮧㪓㳴㔴∳㱊㮙㣭㿝㲺㝩㮤㹋⊱㙀㮛㞩㮙㟋㢇㶧㚩㱸㲵㑃㐽㶶㮙㪧㬘㞨㦈㪙㱖㮠㘲㣋㢙㮩㟝㣫㸧㦔㲚㞘㳳㘗㵥㲙㰲㿚㿗ऐk㮥㱬Бॶ㡚㮙㨎㪍㸡D㲙㱙㢯㘲㞕㦙㮙㳗㪺╱㞩㮚㞖㳴㔣㹺㢙㮙㫭㸿㐳㲙㮦㢈ु㘉㪅㲙㮘㤟xE㲙㢪㵂㔴∕㥩㮙㮩㧰㜑D㲤㭙Λ㕂㚦㵊㮛ज㶗╭E㦥㪐㘳㔿㶼㵋㱱≬䁟AJ㦹ढ㔳㔡㾸㭑N㾣≮A㢋㱰㘳㔳㗷㩖㸀㷮㻰≭∅㭪В㔳㔳㗹㱥㶔㫭⊍Ъ㦗㳳㔴㔳㔴㗷㦓㻉㪈㶬㸵㶯㕃㔳㔳㔳㘁㹻㶻㩉㧋㫆Μ㔳㔳㔳㔳㘯㗜㮸㙦㿗f㔳㔳㔴㔳㔳㘳D㦫㭏v㘳㔳㔳㔳㔳㔳㘴㘲ऐ㕄㔳㔳㔳㘳㔳㘳㔳㔴㔳㔳㔳㔳㔳㕃㔙㠗㼐㵆㦛≐㰓㫸㭡㜫㡗㴕㥡㭮∮㖬㙮㱿㣡㒚㳁㕽⊵≋㝛㓃㬥㨙㙉㾈㔃㞹㬀䃬㫽㕖≰㿀॓㑰㷢㸚䁷㓃㮋㯽㽞ए㝄㡼㪦≙с㛇㵿㔢Σ㓌㭵㬓㒲∪㴆㧯㾂䀝झ㫩॑㡠㴜㗱㵋㮙㬃㒦㧓㚅㱧㫰⋒㯓䀴㻲≀㩌㾵㤜㗱㬍㓩䂓㻩㷨м㙐㾂㦜㽢㲣┅㑦㱮㚤฻㡊㿂㷰㹐㫾㧰⊘㜮㺺㓧㱸㨓㚟๡⋵㽟ॄ㸓㱫㧁䃙g॰\㠨㺼㸤㢸㣻㘈㻆㚌㲽㐸㓿㹙㱝㗟㸎㺹╁㹦㚖㓿㠚┞ि㑴ऻЩ㲞䃟䁅㿠㭊㦏㭋㞽㷤∦㖧㝽㣝㓎㞟㽜㩥㑙㝺㬍㷢㦒╜㵎㲳䀉Σ㺉㡲㰌㽷ॗ㠟㼋㕷╝㬰㶕┏㼌䂦㗮`㧌≲㻸㖰㶐㑎㺧㸞㷑┢㑲㘲㰕㡧㛃O㧖㑾㧍㴧㒭㻬㿀㨿㑾┆㨆㩛㯂㱹㾐㵁[㲢㰮㮅䁺㶹㟗㳀㵻㑭㠓ॱ䁸㵼㑪㭸๐๑≆㺼㥭॑㷽㡖⊼㟍䁝㹳๊╟∀Y㕳㢐㥠㴬㠆䀶⋃㩙㧀㫪㢣㚣㢂㵉䃢㨤㦬㝨㙦╱㳁㞒㗵ज़㣋䁰㘲㤄㚄㽂A㸖≶䂍䀪㜒㿀㣠㺉㼱㐃Ι㯇㤎ढ㞠㑰㡆ए㨭㖦㯛㥒㡓㚧㗉㬇㯽㲴㨠㩾㗏ू㽺㚙㹾㩘㙐㺻㾵㗻㐃㔁㙶㵒㝃㻰┘╒㟏
```

<img width="688" alt="image" src="https://github.com/user-attachments/assets/635915e4-d0fc-4d45-9a3b-08dff2908b72" />

### Opening Project

To open in Godot, simply click code, download zip, unzip it, and open `project.godot`.

If you would just like to test inputs/outputs without opening it in the Godot Editor, download one of the releases.

## Couldn't you do base65536?

Technically yes, but practically it is a worse solution. Anything over U+FFFF is counted as two characters in any practical tests I performed. 0xFFFF is indeed 65536, however there are many control characters, and characters that modify each other by being placed next to each other within that region. The majority of "safe" characters I could find were from the CJK Unified Ideographs Extension B, all of which are above U+FFFF.

In the best case, it shrinks from 342 characters to 256. However in the worst case it is 512. In my tests, 42,720 characters out of the 65,536 (65%) were from Extension B. This means assuming even distribution of the characters, the average size would be 398 characters, which is actually worse than base4096! However, even if it was slightly better in the average case, I think the worst case is more important for this usage.

## Notes

For the vast majority of this experiment, I thought this was a novel idea, but it turns out *qntm* has done pretty extensive work in this sector in JavaScript. I wasn't aware of this until I had already fully implemented the Godot code, and I also think it might be of some use to developers.
