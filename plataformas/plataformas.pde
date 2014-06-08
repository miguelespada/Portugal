import processing.serial.*;
import cc.arduino.*;

import oscP5.*;
import netP5.*;
import java.awt.*;

String IP = "127.0.0.1";

Arduino arduino;

float thres[] = {100, 100, 100};
float prev[] = {0, 0, 0};
float delta[] = {0, 0, 0};
int colores[] = { #FF00FF, #0000FF, #FFFF00};


OscP5 oscP5;
NetAddress myBroadcastLocation, touch; 

void setup () {
// set the window size:
  size(400, 600);        
  frameRate(15);
    
  /*
  String port = "";
  for(int i = 0; i < Serial.list().length; i ++){
    if (Serial.list()[i].contains("usbmodem"))
      port = Serial.list()[i];
  }
  println("Connecting to " + port);
  arduino = new Arduino(this, port, 57600);
  */
  
  oscP5 = new OscP5(this,8000);
  myBroadcastLocation = new NetAddress(IP,12000);
  
  //loadSettings();
  thres[0] = loadSetting("thres_0", 100); 
  thres[1] = loadSetting("thres_1", 100); 
  thres[2] = loadSetting("thres_2", 100); 
  initializeKeys() ;
}

void draw () {
    background(0); 
    for(int p = 0; p < 3; p++){
      fill(colores[p]);
      stroke(colores[p]);
      pushMatrix();
      translate(20, 20);
      text("Thres " + thres[p], 0, 0 + p * 100);
      
    //  processData(map (arduino.analogRead(p),0,1023,0,1), p); 
      if(delta[p] * 1000 > thres[p]) {
        fill(colores[p]);
        stroke(colores[p]);
        ellipse(width/2, 40 + p * 100, 20, 20 );
      }
      popMatrix();
      delta[p] *= 0.95;
    }
}


void processData(float value, int p){
    
    text(int(value * 1000), 20, 20 + p * 100);
    if((value - prev[p]) > delta[p])
      delta[p] = (value - prev[p]);
    
    text(int((value - prev[p]) * 1000), 20, 40 + p * 100);
    text(int(delta[p] * 1000), 20, 60 + p * 100);
    prev[p] = value;
}

void sendValue(float p, float speed) {
  OscMessage myOscMessage = new OscMessage("/jump");  
  myOscMessage.add(p); 
  myOscMessage.add(speed);
  oscP5.send(myOscMessage, myBroadcastLocation);  
  println("sending ", p, speed);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  if(touch == null){
    println("paring touch_osc at  ", theOscMessage.address().replace("/", ""));
    touch = new NetAddress(theOscMessage.address().replace("/", ""), 5001); 
  }
  if(theOscMessage.checkAddrPattern("/0/thres")==true) {
    thres[0] = int(map(theOscMessage.get(0).floatValue(), 0, 1, 0, 200));  
    saveSetting("thres_0", thres[0]);  
    OscMessage myMessage = new OscMessage("/0/thres/0");
    myMessage.add(thres[0]); 
    oscP5.send(myMessage, touch); 
  } 
  if(theOscMessage.checkAddrPattern("/1/thres")==true) {
    thres[1] = int(map(theOscMessage.get(0).floatValue(), 0, 1, 0, 200));  
    saveSetting("thres_1", thres[1]);  
    OscMessage myMessage = new OscMessage("/1/thres/0");
    myMessage.add(thres[1]); 
    oscP5.send(myMessage, touch); 
  } 
  if(theOscMessage.checkAddrPattern("/2/thres")==true) {
    thres[2] = int(map(theOscMessage.get(0).floatValue(), 0, 1, 0, 200));  
    saveSetting("thres_2", thres[2]);  
    OscMessage myMessage = new OscMessage("/2/thres/0");
    myMessage.add(thres[2]); 
    oscP5.send(myMessage, touch); 
  } 
  if(theOscMessage.checkAddrPattern("/0/jump")==true) 
    sendValue(1, 0);
  if(theOscMessage.checkAddrPattern("/1/jump")==true) 
    sendValue(2, 0);
  if(theOscMessage.checkAddrPattern("/2/jump")==true) 
    sendValue(3, 0);
  
}
