# currencyExchange
A simple little app that lets you convert the money in your pocket to the currency where you are.

This is an iOS app written in Swift for CS 411 - Mobile App Development, Spring 2017 at Cal State Fullerton in California.

Most of this code is original from examples on developer.apple.com and "iOS Programming, The Big Nerd Ranch Guide" 6th Ed. by C. Keur and A. Hillegass, and code examples from the good folks at stackoverflow.

The professor for the class is David McLaren.

## Requirements
### A Minimum of two views
This app implements these views:
* a table view that lists the favorited currencies
* a table view that allows favoriting all available currencies
* a regular view where the user types in how much money he wants to convert, and selects a target currency to convert to

### A text field that takes numeric input
The only tricky part will be to enable a delegate observer during text input to prevent multiple decimal places being entered for one number. This technique has already been used on an earlier assignment. It's a nice feature to add to strictly numeric input.

### Currencies, Favorite Currencies, and last-used exchange rate persist across application runs
Important classes in this app will implement the NSCoding protocol to "freeze-dry" the info, and this will be stored in the app's "application sandbox" area of the filesystem.

The only part that won't be saved in this way will be the currently-selected row in the favorite currency table view
and the convert-to currency in the regular view for that currency.

I could go whole-hog and save the last-used convert-to currency for every currency in the larger table. If I get one to work, why not all of them?

### Currency values shall be formatted correctly
Each currency should have its native currency symbol and  shall display with the proper number of minor units.

## Value-Added Features
The customer wanted a basic currency converter app that works. Maybe that's what I delivered.
But I _also_ added these great features:
+ Custom icon of a magenta backpack
+ Flags for each country
+ About view that allows resetting of Favorites
+ Hides UIPicker during text imput to avoid hiding content


## Look, but don't copy-and-paste
If you've found this repo while searching for the class name:

* You can find a better example to plagiarize
* Don't plagiarize

_Daniel Henderson,
student_


## Particularly useful resources:

Currency convert icon from (https://pixabay.com/en/currency-dollar-euro-exchange-rate-311743/)

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

## General World Currency Information

[Table of language codes for iOS](https://gist.github.com/jacobbubu/1836273)

[Table of currencies](https://en.wikipedia.org/wiki/List_of_circulating_currencies)

[There's a currency exchange emoji](http://emojipedia.org/currency-exchange/)

Creating a NumberFormatter for the amount of money wasn't really that hard, after learning enough about the currencySymbol property.
[This is a decent example](http://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift),
though I looked at others to get the gist of it. The part to know is how to convert an ISO currency code to a currency symbol using Apple's already-existing API to do just that.

I brute-forced the minor units in currency.
[Here's the source for how many digits each country] uses(http://www.thefinancials.com/?SubSectionID=curformat).
With that, I formatted a subset of their table into a switch/case statement.

## Difficult programming topics
Or, how I learned to stop worrying and love Swift and iOS.

### Closures
The YQL closure was dutifully gathering up all the exchange rates from the JSON, parsing out the good bits to Swift types, and creating an object for each conversion.

The YQL closure was happily adding key/value pairs to a dictionary, so my controllers could easily look up a conversion rate.

Outside the YQL closure, I was saving that dictionary into the Currency object, for it to use.

Now I know better.

Everything needs to be ready to go for when the closure is entered. If you need to _save something to somewhere_, you better provide a `method to save something somewhere` to the closure, for it to use. Whatever it's going to do, it's going to do inside the closure. There's nothing left when it exits. No dictionary of exchange rates. They go **POOF!**

Don't try to out-think the closure. Don't make the empty dictionary beforehand, and have the closure add key/value pairs to it inside the closure. When you get out, **POOF!**, there ain't nothing there for you but an empty dictionary, like beforehand.

### Singleton
[Great explanation of Singleton pattern on Swift](https://krakendev.io/blog/the-right-way-to-write-a-singleton)

[How to segue programatically](http://stackoverflow.com/questions/27604192/ios-how-to-segue-programmatically-using-swift)

I did not get to this yet. I was going to have a 'Welcome' screen that would load the current exchange rate of all fave currencies. Had to simplify my grand design.

### Short form of a closure to sort Array elements
[For tableView: numberOfRowsInSection, finding the count of just the faves](http://stackoverflow.com/questions/25398608/count-number-of-items-in-an-array-with-a-specific-property-value)

### String function to chop off chars
This seems more complicated than it needs to be.
[Building the queryString in Currency.swift requires chopping off a comma and a space](http://stackoverflow.com/questions/24122288/remove-last-character-from-string-swift-language)

This example is good, because it makes it clear that he's looking for a needle in a haystack
[Finding the position of a char within a string](http://stackoverflow.com/questions/24029163/finding-index-of-character-in-swift-string)

Apparently, the adoption of Unicode, with the potential for multi-byte characters in a String, has made string operations completely befuddling.
[Here's how to remove the first character of a String](http://stackoverflow.com/questions/28445917/what-is-the-most-succinct-way-to-remove-the-first-character-from-a-string-in-swi)

Also, the return type of this lines
```
code.remove(at: code.startIndex)
```
is a `Character`, but the action mutates the string `code` to be one shorter.

Everything you were ever taught about strings is a lie.

## Important Xcode/iOS Development Gotchas
### Accessing URLs in an app

[If I would have payed attention in class, I would not have needed
to google how to override Transport Security](http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http/32560433)

This seems like a good security feature. As a developer, I have to consciously poke holes out to the internet in my app. I was going to use `*.yahoo.com` as my url string, but (besides not working) I thought, why allow access to a whole range when I only need a specific RESTful endpoint?

### Picker

[Tutorial on UIPickerView from December 2016, so recent enough to be helpful](https://makeapppie.com/2016/12/12/data-entry-with-uipickerview/)

### TabView tabs obstructing the bottom of TableViews
[This site explains the setting needed](http://stackoverflow.com/questions/19720216/uitabbar-will-hide-the-last-cell-of-the-uitableview)
It's a check-box in the storyboard for each view that has a TabView as its container. It's "View Controller > Extend Edges > Under Bottom Bars". Turn that off, or write custom scrolling code or add a few dummy/non-functional table rows (seems like a really bad solution).
Maybe there's another way. I don't need the translucent tabs, so this way worked quickest.


## Using enums - try something simpler first
[Making a pseudo-property for enum ISOCode](http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type/24137319#24137319)

Yes, it is mostly a regular expression transformation of the previous lines of enum text.

I refactored out that enum, because it was more trouble than it was worth.

[Making the all-but-one function for enum ISOCode](http://stackoverflow.com/questions/24051633/how-to-remove-an-element-from-an-array-in-swift)

Didn't really work, refactored out the enum.

[Making an enum ISOCode from a string](http://stackoverflow.com/questions/30009788/in-swift-is-it-possible-to-convert-a-string-to-an-enum)

Went with the simplest one:
let a = Foo(rawValue: "a")

Pulled out as part of the great enum refactoring.
