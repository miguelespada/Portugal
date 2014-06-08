import processing.serial.*;
import cc.arduino.*;

import oscP5.*;
import netP5.*;
import java.awt.*;

String IP = "127.0.0.1";

Arduino arduino;

int colores[] = { #FF00FF, #0000FF, #FFFF00};
Player players[];

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
  
  loadSettings();
  initializeKeys();
  
  players = new Player[3];
  for(int p = 0; p < 3; p++)
    players[p] = new Player(p);
  
}

void draw () {
    background(0); 
    for(int p = 0; p < 3; p++){
      //players[p].update();
      pushMatrix();
      translate(20, 20 + p*100);
      players[p].draw();
      popMatrix();
    }
}

void sendJump(float p, float speed) {
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
  
  if(theOscMessage.checkAddrPattern("/0/thres")==true) 
    players[0].processOsc(theOscMessage);
  if(theOscMessage.checkAddrPattern("/1/thres")==true) 
    players[1].processOsc(theOscMessage);
  if(theOscMessage.checkAddrPattern("/2/thres")==true) 
    players[2].processOsc(theOscMessage);
    
  if(theOscMessage.checkAddrPattern("/0/jump")==true) 
    sendJump(1, int(random(0, 6)));
  if(theOscMessage.checkAddrPattern("/1/jump")==true) 
    sendJump(2, int(random(0, 6)));
  if(theOscMessage.checkAddrPattern("/2/jump")==true) 
    sendJump(3,int(random(0, 6))); 
}
