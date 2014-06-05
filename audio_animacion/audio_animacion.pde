import ddf.minim.*;

import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.awt.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;

float acc = 0;

int gain = 50;
float decay = 0.93;

OscP5 oscP5;
NetAddress myBroadcastLocation; 
int levels[] = {0, 100, 500, 700, 800}; 
int level = 0;
int prevLevel = -1;
float back = 0;

void setup()
{
    size(500, 200);
    minim = new Minim(this);
    
    in = minim.getLineIn();
    
    frameRate(25);
 
    oscP5 = new OscP5(this,12000);
    myBroadcastLocation = new NetAddress("192.168.1.39",8000);
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
}
