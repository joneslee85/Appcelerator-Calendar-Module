= Appcelerator Calendar Module Reloaded
===========================================

This is a module that displays an iPhone-like calendar widget, based on the work of Keith Lazuka, dba The Polypeptides.

This version is forked from Scott Montgomerie's original code with fixes.

== Building
--------------

First download the code:
	git clone git@github.com:joneslee85/Appcelerator-Calendar-Module.git

	cd Appcelerator-Calendar-Module

Then build the code.
	./build.py

Install the calendar into your app.
	cp calendarmodule-iphone-xxx.zip ~/Library/Application\ Support/Titanium/

You'll need to at least touch your iPhone app before including it (assuming you're building with Xcode, not Titanium).

== Basic Usage
---------------

To add a view: 

    var calendarView = Ti.Calendar.createView({
        top:0
        /*headerColor: "red",
         calendarColor: "#aaa8a8"*/
    });
    calendarView.show();
    win.add(calendarView);

When a date is selected, a 'dateSelected' event is thrown:

	calendarView.addEventListener('dateSelected', function(e) {
        try {
	       // Do something with the date
       	} catch(e) {
            Ti.API.info(e);
        }
    });

The component is able to show that there is an event on a certain date with a dot icon.  To set which dates are set:
	
	var datesArray = [new Date()];
	calendarView.setDates(datesArray);
	
You can also use the calendar to save a date (and this needs to be refactored):

	calendarView.saveEvent(start, end, event.summary, event.location, event.description);

That's pretty much it!  Any edits/improvements are appreciated.

== Issues
---------

If you do not copy 2 files `icon-back-arrow.png` and `icon-next-arrow.png` to the same folder that contains the `app.js` file, those two buttons will be missing images.