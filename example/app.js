// open a single window
var win = Ti.UI.createWindow({
	title : 'All Calendars',
	backgroundColor : '#FFF',
//	layout : 'vertical',
});

var calendarView = Ti.Calendar.createView({
  top:0,
  //headerColor: "red",
  //calendarColor: "#aaa8a8"
});

var flexSpace = Titanium.UI.createButton({
			systemButton : Titanium.UI.iPhone.SystemButton.FLEXIBLE_SPACE
		});

		var refresh = Titanium.UI.createButton({
			title: 'click me!',
		//	systemButton : Titanium.UI.iPhone.SystemButton.REFRESH,
			height: 50,
			width: 100,
			top: 350,
			left: 50,
		});

		var bttoday = Titanium.UI.createButton({
			title : 'Today',
			style : Titanium.UI.iPhone.SystemButtonStyle.BORDERED,
			height: 50,
			width: 100,
			enabled: true,
			top: 380,
			left: 100,
		});

		var bb1 = Titanium.UI.createButtonBar({
			backgroundColor : '#83389b',
			labels : ['List', 'Day', 'Month']
		});

bttoday.addEventListener('click', function(e){
		calendarView.jumpToday(1);
});
win.add(calendarView);
win.add(bttoday);
//win.add(refresh);


var today = new Date();
var datesArray = [];//[today, nextFiveDay];

for(i=0;i<20;i++){
	var nextDay = new Date();
	nextDay.setDate(today.getDate() + i);
	//Ti.API.info("test: " + nextDay.toDateString());
	datesArray.push(nextDay);
}
calendarView.setDates(datesArray);

//calendarView.moveMonthNext(1);
//calendarView.moveMonthBack(1);

refresh.addEventListener('click', function(e){
	Ti.API.info("fuk");
});

calendarView.addEventListener('dateSelected', function(e) {
  try {
    Ti.API.info(e.date);
  } catch(e) {
  //  Ti.API.info(e);
  }
});

//win.toolbar = [refresh, flexSpace, bb1, flexSpace, bttoday];
win.open();
calendarView.jumpToday(1);
//calendarView.setCalendarColor('white');
