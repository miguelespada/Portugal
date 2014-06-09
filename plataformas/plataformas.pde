import processing.serial.*;
import cc.arduino.*;

import oscP5.*;
import netP5.*;
import java.awt.*;

String IP = "127.0.0.1";

Arduino arduino;

int colores[] = { #FF00FF, #0000FF, #FFFF00};
Player players[];
int gameTime, itemFreq;

OscP5 oscP5;
NetAddress myBroadcastLocation, touch; 

void setup () {
// set the window size:
  size(400, 320);        
  frameRate(15);
    
  
  String port = "";
  for(int i = 0; i < Serial.list().length; i ++){
    if (Serial.list()[i].contains("usbmodem"))
      port = Serial.list()[i];
  }
  println("Connecting to " + port);
 // arduino = new Arduino(this, port, 57600);
  
  
  oscP5 = new OscP5(this,8000);
  myBroadcastLocation = new NetAddress(IP,12000);
  
  loadSettings();
  initializeKeys();
  
  players = new Player[3];
  for(int p = 0; p < 3; p++)
    players[p] = new Player(p);
  
  gameTime = loadSetting("gameTime", 30);
  itemFreq = loadSetting("itemFreq", 3); 
}

void draw () {
    background(0); 
    fill(255);
    text("Game Time: " + gameTime + " item freq " + itemFreq, 10, 10);
    translate(0, 40);
    for(int p = 0; p < 3; p++){
      players[p].update();
      players[p].draw();
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
  touch = new NetAddress(theOscMessage.netAddress().address(), 5001); 
  
  if(theOscMessage.checkAddrPattern("/0/thres")==true) 
    players[0].processOsc(theOscMessage);
  if(theOscMessage.checkAddrPattern("/1/thres")==true) 
    players[1].processOsc(theOscMessage);
  if(theOscMessage.checkAddrPattern("/2/thres")==true) 
    players[2].processOsc(theOscMessage);
  
   if(theOscMessage.checkAddrPattern("/gameTime")==true) {
     gameTime = int(map(theOscMessage.get(0).floatValue(), 0, 1, 10, 60)); 
     saveSetting("gameTime", gameTime); 
     OscMessage myMessage = new OscMessage("/gameTimeLabel");
     myMessage.add(gameTime); 
     oscP5.send(myMessage, touch); 
    oscP5.send(myMessage, myBroadcastLocation);  
  } 
  
  if(theOscMessage.checkAddrPattern("/itemFreq")==true) {
     itemFreq = int(map(theOscMessage.get(0).floatValue(), 0, 1, 1, 30)); 
     saveSetting("itemFreq", itemFreq); 
     OscMessage myMessage = new OscMessage("/itemFreqLabel");
     myMessage.add(itemFreq); 
     oscP5.send(myMessage, touch); 
    oscP5.send(myMessage, myBroadcastLocation); 
  } 
  
  
  if(theOscMessage.checkAddrPattern("/0/jump")==true)
   if( theOscMessage.get(0).floatValue() == 1.0)
      sendJump(1, int(random(0, 6)));
  if(theOscMessage.checkAddrPattern("/1/jump")==true) 
   if( theOscMessage.get(0).floatValue() == 1.0)
    sendJump(2, int(random(0, 6)));
  if(theOscMessage.checkAddrPattern("/2/jump")==true) 
   if( theOscMessage.get(0).floatValue() == 1.0)
    sendJump(3,int(random(0, 6))); 
    
    
}
