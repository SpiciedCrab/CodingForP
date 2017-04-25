## CodingForP
Coding For Plist is a special way to config your view module with plist files, not to adjust all the code in your project.

## LongLong ago..
Look at the situation we meet everyday, we have some json data from our api server, then we need to convert it to our View mannually.

![Cover](https://raw.githubusercontent.com/SpiciedCrab/CodingForP/master/CodingForP_Sample/CodingForP_Sample/GitSource/cover.png)

> The work flow like creating model, binding model, creating array for tableView datasource, etc, got me crazy everyday.. 


...

## Why plist
Then what about generate an object model for each row?
We have the elements like : left title, right title, color, etc..:

<pre><code>struct ConfigRow
{
    // left title
    var key : String!
    
    // right title
    var value : String!
    var sortOrder : Int = 0
    var color : String = ""
}
</code></pre>

Instead of adding the configuration logic in to your Model or ViewModel, we make a plist file in our project. And then deserialize the plist and convert it into dataSource for your View. 

![plist](https://raw.githubusercontent.com/SpiciedCrab/CodingForP/master/CodingForP_Sample/CodingForP_Sample/GitSource/plistScreenshot.png)

So we can get a `[ConfigRow]` array for tableView datasource.

Each time we want to modify the title , color, or even the sort,
#####Only to modify the plist file is enough!.</br>



## When CodingForP tools
We may fill the label in cell using:
<code><pre>leftTitle.text = model.value(forKey : row.value)</code></pre>
Then use some common method to fill the labels using KVC, but what about the complex stringValues?
> `Description :     MemberId + MemberDescription`

Descrpition label may include two parts of fields : memberId and description.</br>
But as we mentioned before , only to modifiy the plist file to change our UI and model.

Then comes the CodingForP:
We can config the plist like this:
![salary](https://raw.githubusercontent.com/SpiciedCrab/CodingForP/master/CodingForP_Sample/CodingForP_Sample/GitSource/salaryscreenShot.png)

And the magic words like : \*&xxxx&*, \*$xxxx*$* will be automatically replaced with the value in the model.

Within CodingForP , If you want to modify the text/color,etc on the view with it, the only thing you need to do is to modify your plist file, not any code in your project!

### Keywords
* `*& xxxx &*`  <br /> Basic format, xxx can be any key 

*  `*$ xxxx $*`   <br /> Currency format, xxx can be any key which need to be displayed as currency like salary.

*  `<| xxxx |>`   <br /> Nullable format, xxx can be any format above, like `<| studentId : \*& sId &* |>` ,  if sId is empty , the whole expression between <| and |> will be empty, so the error display like studentId : "" can be fixed in this format.

*  `*=`   <br /> Default value can be set using this pattern. e.g:  `\*& sId \*= 998 &*` , if sId is empty, the expression will be 998 , not null since you set the default value - 998

### Example
Json :
<pre> let sampleSource = ["userName" : "harly", "userId" : "123", "price" : "" , "salary" : 5000]</pre>

CodingForP expresion:
<pre>-p \*&userId&* \*&userName&* 's salary is <| more than \*$price$*元 |> \*$salary$\* </pre>

After convertion:
<pre>Harly 123 's salary is 5,000.00元</pre>



## Setup and Insallation

####Cocopods:
CodingForP is available through CocoaPods. To install it, simply add the following line to your Podfile:
<pre>pod install CodingForP</pre>

Then you can directly call function:
<pre>func smartTranslate(_ plistString : String ,
                    fromLazyServerJson serverDic : [String : AnyObject])</pre>

Then `plistString` should be your expression in plist, the return value will be the expected result after generation.

## Requirements
* Xcode 8.x
* Swift 3.0