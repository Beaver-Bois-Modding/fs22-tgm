# Tree Growth Manager

![For Farming Simulator 22](https://img.shields.io/badge/Farming%20Simulator-22-10BEFF.svg?style=for-the-badge) [![Releases](https://img.shields.io/github/v/release/Beaver-Bois-Modding/fs22-tgm.svg?style=for-the-badge)](https://github.com/Beaver-Bois-Modding/fs22-tgm/releases)

Make forrestry on your farm more enjoyable and cost effective, by taking control of the amount of time it takes each species of tree to fully grow to maturity.
TGM gives you the ability to change the relative growth rate of a particular tree species from 100% down to 5% - or even up to 200% if you so desire.

TGM extends the built-in game settings menu, where you'll find a new section with the relative growth rates. In a multiplayer setting, this also means that the settings are restricted to admins.

## Distribution

The source for this mod is only provided here for educational and historic purposes, and to allow for potential collaboration. Under no circumstances are you allowed to upload/publish/share this to any mod/file sharing site/service. If you paid for this mod, you were ripped off. If you happen to notice this uploaded to anywhere but the official [ModHub](https://farming-simulator.com/mod.php?lang=en&country=us&mod_id=249491&title=fs2022), please [open an issue](https://github.com/Beaver-Bois-Modding/fs22-tgm/issues/new) to let us know.

## Installation / Releases

Our recommendation will be to get the mod from the official [ModHub](https://farming-simulator.com/mod.php?lang=en&country=us&mod_id=249491&title=fs2022), either downloaded through their web interface or using the in-game interface. There will be times where a new version will be awaiting testing by Giants, but would already be published here. If you can't wait or want to use an older version, go to the [releases](https://github.com/Beaver-Bois-Modding/fs22-tgm/releases) page and download the attached `FS22_treeGrowthManager.zip` file on the particular release.

## Bugs

If you've found a bug, please [open an issue](https://github.com/Beaver-Bois-Modding/fs22-tgm/issues/new) and we'll have a look at it. Thank you!

## Contributions

### Translations

If you'd like to provide a translation for this mod in your language, that'd be very much appreciated.

The mod name and description are located within `src/FS22_treeGrowthManager/modDesc.xml`. To translate these, you'll need to provide a new subsection named after your locale to the `<title>` and `<description>` sections respectively. E.g. if your locale is `de`, it should end up looking something like the following.

```xml
<title>
    <en>Tree Growth Manager</en>
    <de>german title goes here</de>
</title>
<description>
    <en>
<![CDATA[
Make forrestry on your farm more enjoyable and cost effective...
]]>
    </en>
    <de>
<![CDATA[
german description goes here
]]>
    </de>
</description>
```

You can find all other strings in the English translation file in `src/FS22_treeGrowthManager/data/l10n/locale_en.xml`. To make a translation file for your language, copy the English file and rename it to `locale_<your locale>.xml` (e.g. if your locale is `de`, the filename should be `locale_de.xml`). In this file you can place your own name in the `<translationContributors>` tag, and otherwise translate any text within a `text=""` attribute.

The languages supported by FS22 are as follows:
* `br` = Portuguese (Brazil)
* `cs` = Chinese (Simplified)
* `ct` = Chinese (Traditional)
* `cz` = Czech
* `da` = Danish
* `de` = German
* `ea` = Spanish (Latin)
* `en` = English
* `es` = Spanish
* `fc` = French (Canada)
* `fi` = Finnish
* `fr` = French
* `hu` = Hungarian
* `it` = Italian
* `jp` = Japanese
* `kr` = Korean
* `nl` = Dutch
* `no` = Norwegian
* `pl` = Polish
* `pt` = Portuguese
* `ro` = Romanian
* `ru` = Russian
* `sv` = Swedish
* `tr` = Turkish

Your contribution will have to be provided through a [pull request from your own fork of this repository](https://docs.github.com/en/get-started/quickstart/contributing-to-projects).

### Other

Any other desire to collaborate would also be appreciated, but unless it's an exceptional fix for something that's broken, it's unlikely to be accepted.
