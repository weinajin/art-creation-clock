/*IAT800 2015 Fall
 Author: Weina Jin  weinaj@sfu.ca
 Project 1 : a cool clock
 */

/* Art explaination
 this clock only exist when you watch it - here watching means moving the mouse 
 borrowed the idea from quantum mechanics, 
 that time collapses to a certain state when being observed
 you can frozen the shape formation process by pressing the mouse
 */

int width = 750;
int height = 750;
int dotNum = 500;
int centralDotNum = int(dotNum*0.05);
int clockDotNum = int(dotNum*0.6);
int hourDotNum = int(dotNum*0.78);
int minuteDotNum = int(dotNum*0.9);
int hourLen = 140;
int minuteLen = 220;
int r = 2;
int clockR = 260;
float[] startX = new float[dotNum];
float[] startY = new float[dotNum];
float[] endX = new float[dotNum];
float[] endY = new float[dotNum];
float[] nowX = new float[dotNum];
float[] nowY = new float[dotNum];
int step = 60, disappearStep = 40;
int j = 0, k = 0;
boolean mouse = true;
boolean mousePress = false;
float initialT ;
float elapsedT;
float appearTime = 12000;
color[] colorClock = {
  0, #A4CEDB, #A4CEDB, #FFE11A,  #BEDB39, #FD7400
}; 
//bgd, central dot, outline, hour, minute, second

void setup() {
  PFont font;
  font = loadFont("ShreeDev0714-16.vlw");
  textFont(font, 16);
  size(width, height);
  frameRate(10);
  //background color change according to day & night
  if (hour()<12) {
    colorClock[0] = color(map(hour(), 0, 12, 0, 100));
  } else {
    colorClock[0] = color(map(hour(), 12, 24, 100, 0));
  }
  background(colorClock[0]);
  noStroke();
  smooth();
  for (int i = 0; i< dotNum; i++) {
    nowX[i] = random(width);
    nowY[i] = random(height);
  }
}

void draw() {
  if (clockR>290) {
    clockR=250;
  }
  background(colorClock[0]);
  smooth();
  if (mouse) {
    appear();
    elapsedT = millis()-initialT;
    if (elapsedT> appearTime) {
      mouse = false;
    }
  } else {
    disappear();
    initialT = millis();
  }
}


void appear() {
  for (int i = 0; i< dotNum; i++) {
    if (millis()<5000) {
      startX[i] = random(width);
      startY[i] = random(height);
    } else {
      startX[i] = nowX[i];
      startY[i] = nowY[i];
    }
    if ( i < centralDotNum) {//clock central
      while ( dist (endX[i], endY[i], width/2, height/2) > 5 ) {
        PVector central = new PVector(random(width/2-5, width/2+5), random(height/2-5, height/2+5));
        float distance = dist(central.x, central.y, width/2, height/2);
        if (distance < 5) {
          endX[i] = central.x;
          endY[i] = central.y;
        }
      }
    } else if (i >= centralDotNum && i < clockDotNum) { //clock outline
      while ( dist (endX[i], endY[i], width/2, height/2) > (clockR+10)
        || dist(endX[i], endY[i], width/2, height/2) < clockR ) {
        PVector central = new PVector(random(width), random(height));
        float distance = dist(central.x, central.y, width/2, height/2);
        if (distance> clockR && distance < clockR+10) {
          endX[i] = central.x;
          endY[i] = central.y;
        }
      }
    } else if (i >= clockDotNum && i < hourDotNum) {//hour
      float tmpX = map(startX[i], 0, width, width/2, width/2) -width/2;
      float tmpY = map(startY[i], 0, height, height/2, height/2+hourLen)-height/2;
      float angleH = (hour()%12) /12.0 *TWO_PI + minute()/60.0 * PI/6-HALF_PI;
      endX[i] = sqrt( sq(tmpX) + sq(tmpY) ) * cos(angleH) + width/2;
      endY[i] = sqrt( sq(tmpX) + sq(tmpY) ) * sin(angleH)+ height/2;
    } else if ( i >= hourDotNum && i < minuteDotNum) {//minute
      float tmpX = map(startX[i], 0, width, width/2, width/2)-width/2;
      float tmpY = map(startY[i], 0, height, height/2, height/2+minuteLen)-height/2;
      float angleM = minute()/60.0 *TWO_PI-HALF_PI;
      endX[i] = sqrt( sq(tmpX) + sq(tmpY) ) * cos(angleM)+width/2;
      endY[i] = sqrt( sq(tmpX) + sq(tmpY) ) * sin(angleM)+height/2;
    } else if ( i >= minuteDotNum) {//second
      float tmpX = map(startX[i], 0, width, width/2, width/2)-width/2;
      float tmpY = map(startY[i], 0, height, height/2, height/2+minuteLen+20)-height/2;
      float angleM = second()/60.0 *TWO_PI-HALF_PI;
      endX[i] = sqrt( sq(tmpX) + sq(tmpY) ) * cos(angleM)+width/2;
      endY[i] = sqrt( sq(tmpX) + sq(tmpY) ) * sin(angleM)+height/2;
    }
  }

  for (int i = 0; i< dotNum; i++) {
    int wi = 12;  
    if (i >= clockDotNum && i < hourDotNum) { 
      wi = 20;  //width of hour
    } else if ( i > minuteDotNum) { 
      wi = 5;
    }
    float distX = (endX[i] - startX[i])/step;
    float distY = (endY[i] - startY[i])/step;
    float nX = startX[i] + random(distX*j - wi, distX*j);
    float nY = startY[i] + random(distY*j - wi, distY*j);
    //text(second(), nX, nY);
    //ellipse(nX, nY, r, r);
    if (i >= clockDotNum && i < hourDotNum) {
      fill(colorClock[3], random(200, 255));
      text(hour(), nX, nY);
    } else if ( i >= hourDotNum && i < minuteDotNum) {
      fill(colorClock[4], random(150, 200));
      text(minute(), nX, nY);
    } else if ( i >= minuteDotNum) {   //second
      fill(colorClock[5], random(50, 200));
      text(second(), nX, nY);
    } else {
      fill(colorClock[1], random(50, 100));
      text(second(), nX, nY);
    }
  }
  if ( j<step && !mousePress) {
    j++;
  } else { 
    if (mousePress) {
      appearTime+=80;
    }
    k =0;
  }
}

void disappear() {
  j =0;
  float wi = 10;
  for (int i = 0; i< dotNum; i++) {
    startX[i] = random(width);
    startY[i] = random(height);
    float distX = (startX[i] - endX[i])/disappearStep;
    float distY = (startY[i] - endY[i])/disappearStep;
    nowX[i] = endX[i] + random(distX*k - wi, distX*k);
    nowY[i] = endY[i] + random(distY*k - wi, distY*k);
    if (i >= clockDotNum && i < hourDotNum) {
      fill(colorClock[3], random(200, 255));
      text(hour(), nowX[i], nowY[i]);
    } else if ( i >= hourDotNum && i < minuteDotNum) {
      fill(colorClock[4], random(150, 200));
      text(minute(), nowX[i], nowY[i]);
    } else if ( i >= minuteDotNum) {
      fill(colorClock[5], random(50, 200));
      text(second(), nowX[i], nowY[i]);
    } else {
      fill(colorClock[1], random(50, 100));
      text(second(), nowX[i], nowY[i]);
    }
  }
  if (k < disappearStep) {
    clockR++;
    k++;
  }
  appearTime=12000;
}

void mouseClicked() {
  mouse = true;
}

void mousePressed() {
  mousePress = true;
}

void mouseDragged() {
  mouse = true;
}

void mouseMoved() {
  mouse = true;
}
void mouseReleased() {
  mousePress = false;
}

