iDev Reader
=============
![iDev Reader Icon](http://appserver.ablfx.com/idevreader/icon_256.png)


INFO
-------------
"iDev Reader" is simple little App for iOS that'll give you the ability to
browse the latest articles from [iDevBlogADay](http://idevblogaday.com) on the go.


USAGE
-------------
The Application does not parse the iDevBlogADay RSS feed directly in the
application, it relies on a web-service (written in PHP) that parses the RSS
and hands it to the app in JSON format.

You can leave the source code unchanged and it will still work, since the app
is currently pointing to my own server. However you can upload the files
to your own server that are to found in the sub-directory 
"iDev Reader Serverside".

FUTURE PLANS
-------------
*   iPad Compatibility
*   Possiblitly to save articles locally (favorites)
*   Share over twitter / email function

LICENSE
-------------
You may use this piece of software as you please ;) Only restriction you may not 
sell/redistribute the included images.

The App makes use of following 3rd party Classes:

*   [SVHTTPRequest](https://github.com/samvermette/SVHTTPRequest)
*   [SVProgressHUD](https://github.com/samvermette/SVProgressHUD)

SCREENSHOTS
-------------
![Screenshot 1](http://appserver.ablfx.com/idevreader/screen1.jpg)

![Screenshot 2](http://appserver.ablfx.com/idevreader/screen2.jpg)