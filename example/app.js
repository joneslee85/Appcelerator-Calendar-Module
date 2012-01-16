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
var datesArray = [];//[today, nextFiveDay];

for(i=0;i<8;i++) {
  var nextDay = new Date();
  nextDay.setDate(today.getDate() + i);
  Ti.API.info("test: " + nextDay.toDateString());
  datesArray.push(nextDay);
}
calendarView.setDates(datesArray);

calendarView.addEventListener('monthSelected', function (e) {
    Ti.API.log(e);
});

calendarView.addEventListener('dateSelected', function(e) {
  try {
   // Ti.API.info(e.date);
  } catch(e) {
  //  Ti.API.info(e);
  }
});

win.open();
