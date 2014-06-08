class Player{
 int port;
 float thres;
 float prev, prevDelta = 0, delta = 0;
 int state = 0;
 boolean jump = false;
 float lastJumpTime;
 
 Player(int port){
  this.port = port;
  thres = loadSetting("thres_" + port, 0.5); 
 }
 
 void update(){
   if(millis() - lastJumpTime > 10000) {
     state = 0;
     prevDelta = 0;  
   }
   float value = 0;
  // value = map(arduino.analogRead(port),0,1023,0,1);
   
   if(mousePressed) 
     value = map(mouseY, 0, height, 0, 1);
   delta = value - prev;
   if(delta > thres){
     if (delta > prevDelta) 
       state += 1; 
     else
       state -= 1; 
       
     if(state < 0) state = 0;
     prevDelta = delta;  
     sendJump(port, state);
     lastJumpTime = millis();
     jump = true;
   }
  
   prev = value;
 }
 
 void draw(){
    fill(colores[port]);
    stroke(colores[port]);
    text("Thres " + thres, 0, 0);
    text("State " + state, 0, 20);
    text("jump " + delta, 0, 40);
    text("prev jump " + prevDelta, 0, 60);
    if(jump){
      jump = false;
      ellipse(150, 50, 20, 20);
    }
 }
 
 void processOsc(OscMessage theOscMessage){
    thres = theOscMessage.get(0).floatValue();  
    saveSetting("thres_" + port, thres);  
    OscMessage myMessage = new OscMessage("/" + port +"/thres/0");
    myMessage.add(thres); 
    oscP5.send(myMessage, touch); 
 }
}

