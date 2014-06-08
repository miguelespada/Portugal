class Player{
 int port;
 float thres;
 float prev, prevDelta = 0, delta = 0, deltaInfo;
 int state = 0;
 boolean jump = false;
 float lastJumpTime;
 int size = 0;
 
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
     deltaInfo = delta;
     if (delta > prevDelta) 
       state += 1; 
     else
       state -= 1; 
       
     if(state < 0) state = 0;
     prevDelta = delta;  
     sendJump(port + 1, state);
     lastJumpTime = millis();
     jump = true;
   }
   deltaInfo *= 0.95;
  
   prev = value;
 }
 
 void draw(){
   
    pushMatrix();
      translate(20, 20 + port*100);
    fill(colores[port]);
    stroke(colores[port]);
    text("Thres " + int(thres * 1000), 0, 0);
    text("State " + state, 0, 20);
    text("jump " + delta, 0, 40);
    text("prev jump " + prevDelta, 0, 60);
    if(jump){
      jump = false;
      size = 20;
    }
    
      ellipse(150, 50, size, size);
      size *= 0.9;
    popMatrix();
    
      pushMatrix();
      translate(0, thres * height);
      line(width/2, 0, width, 0);
      popMatrix();
      
      
      pushMatrix();
      translate(width/2 + 50, 0);
      line(port * 50, 0, port * 50, deltaInfo * height); 
      ellipse(port * 50, prevDelta * height, 3, 3); 
      popMatrix();
 }
 
 void processOsc(OscMessage theOscMessage){
    thres = theOscMessage.get(0).floatValue();  
    saveSetting("thres_" + port, thres);  
    OscMessage myMessage = new OscMessage("/" + port +"/thres/0");
    myMessage.add(thres); 
    oscP5.send(myMessage, touch); 
 }
}

