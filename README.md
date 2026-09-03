# 🇨🇿 Česká lokalizace pro Battle Realms: Zen Edition (Steam)

[![Verze češtiny](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fraw.githubusercontent.com%2Fnosmall%2FBattleRealmsZenCestinaRelease%2Fmain%2FVERZE.txt&search=%5Cb(v%5B0-9%5D%2B%5C.%5B0-9%5D%2B)%5Cb&label=Verze%20%C4%8De%C5%A1tiny&color=success)](https://github.com/nosmall/BattleRealmsZenCestinaRelease/releases/latest)
[![Kompatibilita](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fraw.githubusercontent.com%2Fnosmall%2FBattleRealmsZenCestinaRelease%2Fmain%2FVERZE.txt&search=%28%5B0-9%5D%2B%5C.%5B0-9%5D%2B%5Cs%2A%5C%28Build%5Cs%2A%5B0-9.%5D%2B%5C%29%29&label=Hra%20verze&color=blue)](https://github.com/nosmall/BattleRealmsZenCestinaRelease)
[![Stav](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fraw.githubusercontent.com%2Fnosmall%2FBattleRealmsZenCestinaRelease%2Fmain%2FVERZE.txt&search=%28%5B0-9.%5D%2B%5Cs%2A%25%5Cs%2A%5C%28%5B0-9%5D%2B%5Cs%2Az%5Cs%2A%5B0-9%5D%2B%5Cs%2Asoubor%5B%5E%0D%0A%5D%2A%5C%29%29&label=Dokon%C4%8Deno&color=brightgreen)](https://github.com/nosmall/BattleRealmsZenCestinaRelease)
[![Licence](https://img.shields.io/badge/Licence-Nekomer%C4%8Dn%C3%AD%20fanou%C5%A1kovsk%C3%A1-orange)](https://github.com/nosmall/BattleRealmsZenCestinaRelease)

Kompletní komunitní český překlad pro strategickou legendu **Battle Realms: Zen Edition** na Steamu.

---

## 📥 Ke stažení

Vyberte si edici, která vám více vyhovuje (odkazy vždy stáhnou nejnovější verzi):

| Edice | Co obsahuje | Velikost ke stažení | Odkaz ke stažení |
| :--- | :--- | :---: | :--- |
| 📦 **LITE edice** | Kompletní české texty rozhraní, menu, veškerá nastavení, cíle misí, popisky jednotek, budov a kláves. | **~2.7 MB** | 👉 **[Stáhnout LITE (ZIP)](https://github.com/nosmall/BattleRealmsZenCestinaRelease/releases/latest/download/BattleRealms_Zen_Cestina_LITE.zip)** |
| 🎬 **FULL edice** | **Vše z LITE** + navíc **kompletní české titulky ke všem dabovaným dialogům a in-game cutscénám** (všech 11 herních audio archivů). | **~350 MB** | 👉 **[Stáhnout FULL (ZIP)](https://github.com/nosmall/BattleRealmsZenCestinaRelease/releases/latest/download/BattleRealms_Zen_Cestina_FULL.zip)** |

*(Všechny vydané verze a přehled změn naleznete na stránce **[Releases](https://github.com/nosmall/BattleRealmsZenCestinaRelease/releases)**)*

---

## ✨ Co lokalizace obsahuje

Překlad pokrývá **100 % celé hry** (celkem **6430 textových řádků** v 93 souborech):
* **Uživatelské rozhraní (4 313 řádků):** Hlavní menu, nastavení grafiky a zvuku, profily hráčů, Steam Workshop i síťová hra (Multiplayer).
* **Mluvené dialogy a cutscény (2 117 řádků):** Kompletní české titulky ke všem dabovaným dialogům v misích a in-engine cutscénách v 11 herních archivech (součást FULL edice).
* **Příběhové kampaně:** Kompletní příběh pro Kenjiho cestu (**Dragon & Serpent**) i datadisk **Winter of the Wolf** (Grayback).
* **Taktické nápovědy:** Popisy jednotek, budov, vylepšení a speciálních schopností v dolním panelu.
* **Bitevní atmosféra:** Citáty na načítacích obrazovkách a hlášení během bitev.
* **Ovládání:** Kompletní české popisky příkazů v nastavení kláves.

> [!NOTE]
> Pro zobrazení českých dialogů během misí a cutscén se v nastavení hry ujistěte, že máte zapnuté **Titulky (Subtitles)**.
> Pro zachování maximálního taktického přehledu zůstávají názvy jednotek, budov a postav mezinárodní (*Peasant, Samurai, Dojo, Keep, Kenji, Grayback*). Veškeré jejich akce, schopnosti, statistiky a popisy jsou kompletně v češtině.
> Z důvodu technického omezení bitmapových fontů původního enginu jsou texty zpracovány v **čistém ASCII bez diakritiky**, což zaručuje 100% spolehlivé a čitelné zobrazení bez vynechaných písmen.

---

## 🚀 Rychlá instalace (1 kliknutí)

1. Stáhněte a rozbalte stažený archiv ZIP (např. na Plochu nebo do Stažených souborů).
2. Ujistěte se, že hra Battle Realms právě neběží.
3. Dvakrát klikněte na soubor **`instalovat_cestinu.bat`**.

Skript sám:
* Automaticky prohledá vaše disky a najde Steam instalaci hry.
* Vytvoří bezpečné zálohy původní angličtiny (`*.original`).
* Nakopíruje české soubory do hry bez jakéhokoliv zbytečného smetí.

---

## 🛠️ Ruční instalace (bez skriptů)

Pokud nechcete spouštět žádné dávkové skripty:
1. Otevřete složku s hrou na Steamu:  
   `...\Steam\steamapps\common\Battle Realms\`
2. Ze staženého balíčku ze složky `data/`:
   - Zkopírujte `Interface_Text.H2O` do herní složky `Interface/`.
   - Pokud instalujete FULL edici, zkopírujte obsah `data/Sound/Dialogue/` do herní složky `Sound/Dialogue/`.

---

## 🔄 Přepínání jazyka (Čeština / Angličtina)

Součástí balíčku je také pomocný nástroj **`prepnout_jazyk.bat`**, kterým můžete kdykoliv mezi češtinou a angličtinou libovolně přepínat. Pro rychlé obnovení původní angličtiny poslouží **`obnovit_anglictinu.bat`**.

---

## 🐛 Hlášení chyb a zpětná vazba

Našli jste ve hře překlep, nepřesný text nebo nesrovnalost?  
Budeme rádi za vaši pomoc! Založte prosím hlášení v sekci **[Issues](https://github.com/nosmall/BattleRealmsZenCestinaRelease/issues)** – stačí kliknout na **New Issue** a vybrat připravený formulář.

---

## 👥 Autoři, poděkování a licence

* **Autor lokalizace a technická realizace:** **nosmall**
* **Metodika:** Technická integrace a adaptace textů za asistence moderních AI lingvistických nástrojů s pečlivou lidskou kontrolou a korekturou.
* **Právní doložka:** Jedná se o neoficiální fanouškovskou lokalizaci poskytovanou zcela zdarma pro komunitu hráčů. Hra *Battle Realms: Zen Edition*, herní materiály, grafika a ochranné známky jsou duševním vlastnictvím společností **Crape Dynamics** a **Liquid Entertainment**.

---

## ☕ Podpora autora (na dobrou kávu)

Překlad vznikl z čistého nadšení pro tuto legendární strategii a je pro všechny hráče zcela zdarma. Pokud vám čeština udělala radost, ušetřila čas nebo zpříjemnila zážitek ze hry a chtěli byste autora symbolicky pozvat **na šálek dobré kávy**, můžete poslat libovolný dobrovolný příspěvek:

* **Banka:** Air Bank
* **Číslo účtu:** `1080511082/3030`
* **Zpráva pro příjemce:** `Podekovani za BR ZEN cestina`

<br>

<p align="center">
  <img src="https://api.paylibo.com/paylibo/generator/image?accountNumber=1080511082&bankCode=3030&message=Podekovani%20za%20BR%20ZEN%20cestina&size=200" alt="QR platba - Poděkování za češtinu" width="180" /><br>
  <em>(Jednoduše naskenujte v aplikaci své banky – částku si zvolte sami. Děkuji za podporu!)</em>
</p>

---

## ⚖️ Zřeknutí se odpovědnosti (Disclaimer)

Tento software a lokalizační soubory jsou poskytovány **„TAK, JAK JSOU“ (AS IS)**, bez jakékoli výslovné či předpokládané záruky. Autor nenese žádnou odpovědnost za jakékoliv případné chyby, nestabilitu hry, ztrátu uložených pozic ani jiné škody vzniklé instalací nebo používáním tohoto neoficiálního rozšíření. Instalace probíhá plně na vlastní odpovědnost uživatele.
