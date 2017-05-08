README.md

Currency convert icon from https://pixabay.com/en/currency-dollar-euro-exchange-rate-311743/

Favorites icon was created in Adobe Illustrator. The folder icon is an asset provided by Illustrator.
The currency characters are available in almost all fonts. The font used is Helvetica, 
but it's too small to tell. The composition was done by the software creator, Daniel Henderson.

The national flags are from Wikipedia, and are all open-source. Conversion from SVG to PNG was
done in Photoshop by the software creator, Daniel Henderson.

Much thanks to the authors of the book "iOS Programming, The Big Nerd Ranch Guide", 6th Edition, 
Christian Keur and Aaron Hillegass. 
* specifics on creating tabviews and subviews of it
* adding icons and text to each tab
* more to list, I'm sure



Table of language codes for iOS
https://gist.github.com/jacobbubu/1836273

Table of currencies
https://en.wikipedia.org/wiki/List_of_circulating_currencies


How to segue programatically:
http://stackoverflow.com/questions/27604192/ios-how-to-segue-programmatically-using-swift
I did not get to this yet. 
I was going to have a 'Welcome' screen 
that would load the current exchange rate of all fave currencies.
Had to simplify my grand design.

Making a pseudo-property for enum ISOCode:
http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type/24137319#24137319
yes, it is mostly a regular expression transformation of the previous lines of enum text

Making the all-but-one function for enum ISOCode:
http://stackoverflow.com/questions/24051633/how-to-remove-an-element-from-an-array-in-swift

For tableView: numberOfRowsInSection, finding the count of just the faves:
http://stackoverflow.com/questions/25398608/count-number-of-items-in-an-array-with-a-specific-property-value

Building the queryString in Currency.swift requires chopping off a comma and a space:
http://stackoverflow.com/questions/24122288/remove-last-character-from-string-swift-language

Making an enum ISOCode from a string:
http://stackoverflow.com/questions/30009788/in-swift-is-it-possible-to-convert-a-string-to-an-enum
Went with the simplest one:
let a = Foo(rawValue: "a")

