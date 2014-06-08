import ddf.minim.*;

import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.awt.*;

String IP = "192.168.1.57";
String touch_IP;
Minim minim;
AudioInput in;
AudioRecorder recorder;

float acc = 0;

int gain = 50;
float decay = 0.93;

OscP5 oscP5;
NetAddress myBroadcastLocation, touch; 
int levels[] = {0, 100, 500, 700, 1200}; 
int level = 0;
int prevLevel = -1;
float back = 0;

void setup()
{
    size(500, 200);
    minim = new Minim(this);
    
    in = minim.getLineIn();
    
    frameRate(25);
 
    oscP5 = new OscP5(this,8000);
    myBroadcastLocation = new NetAddress(IP,8000);
    loadSettings();
    gain = loadSetting("gain", 50); 
    decay = loadSetting("decay", 0.93); 
    initializeKeys() ;
}

void draw()
{
    background(0); 
    stroke(255);
   
    float max = 0;
    for(int i = 0; i < in.bufferSize() - 1; i++)
      if(in.left.get(i) > max) max = in.left.get(i);
    
    acc += max * gain;
    acc *= decay;
    
    textSize(30);
    for(int i = 0; i < levels.length; i ++){
      if(acc > levels[i]) level = i;
      else break;
    }
    text("ACC: " + int(acc), width/2, 50);
    text("LEVEL: " + level, width/2, 100);
    if(prevLevel != level){
      sendValue(level);
      prevLevel = level;
     back = 255;
    }
  pushStyle();
  fill(back);
  back = back * 0.95;
  ellipse(20, 20, 19, 19);
  popStyle();
  
  textAlign(LEFT);
  textSize(12);
  text("Decay [d]: " + int(decay*10000)/10000.0 + " Gain [g]: " +  gain, 10, 50);
  
  for(int i = 0; i < levels.length; i ++)
     text("Level " + i + " - " + levels[i], 10, 70 + i * 14);
}

void sendValue(int level) {
  OscMessage myOscMessage = new OscMessage("/anima");  
  myOscMessage.add(level);
  oscP5.send(myOscMessage, myBroadcastLocation);
  println("sending ", level);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  if(touch == null){
    println("paring touch_osc at  ", theOscMessage.address().replace("/", ""));
    touch = new NetAddress(theOscMessage.address().replace("/", ""), 5001); 
  }
  if(theOscMessage.checkAddrPattern("/gain")==true) {
    gain = int(map(theOscMessage.get(0).floatValue(), 0, 1, 0, 200));  
    saveSetting("gain", gain);  
    OscMessage myMessage = new OscMessage("/1/gain");
    myMessage.add(gain); 
    oscP5.send(myMessage, touch); 
  } 
  if(theOscMessage.checkAddrPattern("/decay")==true) {
     decay = map(theOscMessage.get(0).floatValue(), 0, 1, 0.85, 1); 
     saveSetting("decay", decay); 
     OscMessage myMessage = new OscMessage("/1/decay");
     myMessage.add(decay); 
     oscP5.send(myMessage, touch); 
  } 
}
