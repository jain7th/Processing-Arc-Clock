//Clock Global Variables
float cInnerRadius;
float cOuterRadius;
float cArcDistance;
int cStrokeWeight;
int cTypeSize;
float[] cMappedValue = new float[6];
String[] cPrintValueShort = new String[6];
String[] cPrintValueLong = new String[6];
boolean cLeapYear;
int cColorHue;
String dateString;
int cWeekdayA;
int cWeekdayY;
int cWeekdayM;
int cWeekdayD;
int monthLength;
String cDrawValue;
int cI;
float rotPerChar;
int inverseString;
int textOrientationSwitch;
int secondTracker = 0;
int millisTracker = 0;
int interpolatedSeconds;
float interpolatedMinutes;
float interpolatedHours;
float interpolatedWeekday;
float interpolatedDay;
float interpolatedMonth;

PFont cFont;


int whiteLines = 0;
int scaler;


void setup() {
  size(1280, 720);
  scaler = min(width, height);
  //  frameRate(30);
  colorMode(HSB, 100);
  smooth();

  setupClock();
}

void draw() {
  background(10);

  drawClock();
}

void setupClock() {
  cInnerRadius = floor(scaler*0.3);
  cOuterRadius = ceil(scaler*0.8);
  cArcDistance = floor((cOuterRadius - cInnerRadius) / 6);
  cStrokeWeight = floor(cArcDistance*0.45);
  cTypeSize = floor(cStrokeWeight*0.55);

  cFont = createFont("SansSerif", cTypeSize);
}

void drawClock() {
  pushMatrix();

  translate(width*0.5, height*0.5);

  rotate(radians(20));

  noFill();
  stroke(50, 90);

  //Map Seconds

  if (second() != secondTracker) {
    millisTracker = millis();
    secondTracker = second();
  }  

  interpolatedSeconds = second()*1000 + (millis() - millisTracker);

  cMappedValue[0] = map(interpolatedSeconds, 0, 59999, 20, 345);

  //Set Draw Strings for Seconds
  cPrintValueShort[0] = str(second());
  if (second() == 1) {
    cPrintValueLong[0] = str(second()) + " Second";
  } 
  else {
    cPrintValueLong[0] = str(second()) + " Seconds";
  }

  //Map Minutes
  interpolatedMinutes = minute() + norm(interpolatedSeconds, 0, 59999);
  cMappedValue[1] = map(interpolatedMinutes, 0, 59, 20, 345);

  //Set Draw Strings for Minutes
  cPrintValueShort[1] = str(minute());
  if (minute() == 1) {
    cPrintValueLong[1] = str(minute()) + " Minute";
  } 
  else {
    cPrintValueLong[1] = str(minute()) + " Minutes";
  }

  //Map Hours
  interpolatedHours = hour() + norm(interpolatedMinutes, 0, 59999);
  cMappedValue[2] = map(interpolatedHours, 0, 24, 20, 345);

  //Set Draw Strings for Hours
  cPrintValueShort[2] = str(hour());
  if (hour() == 1) {
    cPrintValueLong[2] = str(hour()) + " Hour";
  } 
  else {
    cPrintValueLong[2] = str(hour()) + " Hours";
  }

  //Calculate Weekday
  cWeekdayA = (14 - month())/12;
  cWeekdayY = year() - cWeekdayA;
  cWeekdayM = month() + 12*cWeekdayA - 2;
  cWeekdayD = (day() + cWeekdayY + cWeekdayY/4 - cWeekdayY/100 + cWeekdayY/400 + (31*cWeekdayM)/12) % 7;

  //Set Frist Weekday To Monday
  if (cWeekdayD == 0) {
    cWeekdayD = 7;
  }

  //Map Weekday
  interpolatedWeekday = cWeekdayD + norm(interpolatedHours, 0, 24);
  cMappedValue[3] = map(interpolatedWeekday, 1, 7, 20, 345);

  //Set Draw Strings for Weekday
  switch(cWeekdayD) {
  case 1:
    cPrintValueShort[3] = "Mon";
    cPrintValueLong[3] = "Monday";
    break;

  case 2:
    cPrintValueShort[3] = "Tue";
    cPrintValueLong[3] = "Tuesday";
    break;

  case 3:
    cPrintValueShort[3] = "Wed";
    cPrintValueLong[3] = "Wednesday";
    break;

  case 4:
    cPrintValueShort[3] = "Thu";
    cPrintValueLong[3] = "Thursday";
    break;

  case 5:
    cPrintValueShort[3] = "Fri";
    cPrintValueLong[3] = "Friday";
    break;

  case 6:
    cPrintValueShort[3] = "Sat";
    cPrintValueLong[3] = "Saturday";
    break;

  case 7:
    cPrintValueShort[3] = "Sun";
    cPrintValueLong[3] = "Sunday";
    break;
  }


  //Check for Leap Year
  if (year()%4 == 0) {
    if (year()%100 == 0) {
      if (year()%400 == 0) {
        cLeapYear = true;
      } 
      else {
        cLeapYear = false;
      }
    }
    else {
      cLeapYear = true;
    }
  } 
  else {
    cLeapYear = false;
  }

  //Map Days
  if (month() == 2 && cLeapYear == true) {
    monthLength = 29;
  } 
  else if (month() == 2 && cLeapYear == false) {
    monthLength = 28;
  } 
  else if (month()%2 == 0) {
    monthLength = 30;
  } 
  else {
    monthLength = 31;
  }

  interpolatedDay = day() + norm(interpolatedHours, 0, 24);
  cMappedValue[4] = map(interpolatedDay, 1, monthLength, 20, 345);

  //Set Short Draw Strings for Days
  cPrintValueShort[4] = str(day());

  //Set Long Draw Strings for Days
  if (day() == 1) {
    cPrintValueLong[4] = "1st";
  } 
  else if (day() == 2) {
    cPrintValueLong[4] = "2nd";
  } 
  else if (day() == 3) {
    cPrintValueLong[4] = "3rd";
  } 
  else {
    cPrintValueLong[4] = str(day()) + "th";
  }


  //Map Months
  interpolatedMonth = month() + norm(interpolatedDay, 1, monthLength);
  cMappedValue[5] = map(interpolatedMonth, 1, 12, 20, 345);

  //Set Short Draw Strings for Months
  cPrintValueShort[5] = str(month());

  //Set Draw Strings for Months
  switch(month()) {
  case 1:
    cPrintValueLong[5] = "January";
    cPrintValueShort[5] = "Jan";
    break;

  case 2:
    cPrintValueLong[5] = "February";
    cPrintValueShort[5] = "Feb";
    break;

  case 3:
    cPrintValueLong[5] = "March";
    cPrintValueShort[5] = "Mar";
    break;

  case 4:
    cPrintValueLong[5] = "April";
    cPrintValueShort[5] = "Apr";
    break;

  case 5:
    cPrintValueLong[5] = "May";
    cPrintValueShort[5] = "May";
    break;

  case 6:
    cPrintValueLong[5] = "June";
    cPrintValueShort[5] = "Jun";
    break;

  case 7:
    cPrintValueLong[5] = "July";
    cPrintValueShort[5] = "Jul";
    break;

  case 8:
    cPrintValueLong[5] = "August";
    cPrintValueShort[5] = "Aug";
    break;

  case 9:
    cPrintValueLong[5] = "September";
    cPrintValueShort[5] = "Sep";
    break;

  case 10:
    cPrintValueLong[5] = "October";
    cPrintValueShort[5] = "Oct";
    break;

  case 11:
    cPrintValueLong[5] = "November";
    cPrintValueShort[5] = "Nov";
    break;

  case 12:
    cPrintValueLong[5] = "December";
    cPrintValueShort[5] = "Dec";
    break;
  }

  //Draw Arcs
  for (int i = 0; i < 6; i++) {
    //Map and Apply Color
    if (whiteLines == 0) {
      cColorHue = round(map(cMappedValue[i], 20, 345, 62, 2));
      stroke(cColorHue, 80, 100);
    } 
    else {
      stroke(100, 90);
    }

    //Apply Stroke Weight
    strokeWeight(cStrokeWeight);    

    //Draw Arc
    arc(0, 0, cInnerRadius + cArcDistance*i, cInnerRadius + cArcDistance*i, 0, radians(cMappedValue[i]));


    //Write Draw Values
    if ((cMappedValue[i]*2) < textWidth(cPrintValueLong[i]) ) {
      cDrawValue = cPrintValueShort[i];
    } 
    else {
      cDrawValue = cPrintValueLong[i];
    }

    //Set Font
    textFont(cFont);
    textAlign(LEFT); 
    fill(10, 90); 

    //Set Matrix Before Text Drawing
    pushMatrix();

    for (cI = 0; cI < cDrawValue.length(); cI++) {


      if (cMappedValue[i] > 175) {
        pushMatrix();

        //Move Text Along With Bar
        rotate(radians(cMappedValue[i] - (180. * (textWidth(cDrawValue)*2.)) / (PI * (cInnerRadius + cArcDistance*i))));
        
        translate((cInnerRadius + cArcDistance*i)*0.5, 0);

        rotate(radians(90));

        text(cDrawValue.charAt(cI), 0, 5);

        popMatrix();

        //Rotation per Character
        rotPerChar = (180. * (textWidth(cDrawValue.charAt(cI))*2.)) / (PI * (cInnerRadius + cArcDistance*i));

        rotate(radians(rotPerChar));
      } 
      else {
        pushMatrix();

        //Move Text Along With Bar
        rotate(radians(cMappedValue[i] - (180. * (textWidth(cDrawValue)/8.)) / (PI * (cInnerRadius + cArcDistance*i))));

        translate((cInnerRadius + cArcDistance*i)*0.5, 0);

        rotate(radians(-90));

        text(cDrawValue.charAt(cI), 0, 5);

        popMatrix();

        //Rotation per Character
        rotPerChar = -((180. * (textWidth(cDrawValue.charAt(cI))*2.)) / (PI * (cInnerRadius + cArcDistance*i)));

        rotate(radians(rotPerChar));
      }
    }
    noFill();

    popMatrix();
  }
  popMatrix();
}

