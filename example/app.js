// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var calendarView = Ti.Calendar.createView({
  top:0
  //headerColor: "red",
  //calendarColor: "#aaa8a8"
});


win.add(calendarView);

var today = new Date();
var nextFiveDay = new Date();
nextFiveDay.setDate(today.getDate()+5);

var datesArray = [today, nextFiveDay];
calendarView.setDates(datesArray);


calendarView.addEventListener('dateSelected', function(e) {
  try {
    alert(e.date);
  } catch(e) {
    Ti.API.info(e);
  }
});

win.open();