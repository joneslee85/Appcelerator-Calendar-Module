// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var calendarView = Ti.Calendar.createView({
  top:0,
  //headerColor: "red",
  //calendarColor: "#aaa8a8"
});


win.add(calendarView);

var today = new Date();
var nextFiveDay = new Date();
var nextSixDay = new Date();
nextFiveDay.setDate(today.getDate()+5);
nextSixDay.setDate(today.getDate() + 8);
Ti.API.info(nextFiveDay);

var datesArray = [];//[today, nextFiveDay];
datesArray.push(today);
datesArray.push(nextFiveDay);
datesArray.push(nextSixDay);
calendarView.setDates(datesArray);


calendarView.addEventListener('dateSelected', function(e) {
  try {
   // Ti.API.info(e.date);
  } catch(e) {
  //  Ti.API.info(e);
  }
});

win.open();