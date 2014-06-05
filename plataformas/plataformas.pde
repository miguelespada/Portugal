import processing.serial.*;
import cc.arduino.*;

import oscP5.*;
import netP5.*;
import java.awt.*;


Arduino arduino;

float thres[] = {100, 100, 100};
float prev[] = {0, 0, 0};
float delta[] = {0, 0, 0};
int colores[] = { #FF00FF, #0000FF, #FFFF00};


OscP5 oscP5;
NetAddress myBroadcastLocation; 



void setup () {
// set the window size:
  size(400, 600);        

  
   frameRate(25);
    
    oscP5 = new OscP5(this,12000);
    myBroadcastLocation = new NetAddress("192.168.1.39",8000);
  
  String port = "";
  for(int i = 0; i < Serial.list().length; i ++){
    if (Serial.list()[i].contains("usbmodem"))
      port = Serial.list()[i];
  }
   println("Connecting to " + port);
   arduino = new Arduino(this, port, 57600);
    
  background(0);
  
  
}

void draw () {
    background(0); 
    for(int p = 0; p < 3; p++){
      processData(map (arduino.analogRead(p),0,1023,0,1), p); 
      if(delta[p] * 1000 > thres[p]) {
        fill(colores[p]);
        stroke(colores[p]);
        ellipse(width/2, 40 + p * 100, 20, 20 );
      }
      delta[p] *= 0.95;
    }
}


void keyPressed(){
}

void processData(float value, int p){
        fill(colores[p]);
        stroke(colores[p]);
    text(int(value * 1000), 20, 20 + p * 100);
    if((value - prev[p]) > delta[p])
      delta[p] = (value - prev[p]);
    
    text(int((value - prev[p]) * 1000), 20, 40 + p * 100);
    text(int(delta[p] * 1000), 20, 60 + p * 100);
    prev[p] = value;
}

void sendValue() {
  OscMessage myOscMessage = new OscMessage("/jump");  
  myOscMessage.add(0);
  oscP5.send(myOscMessage, myBroadcastLocation);
}
