boolean keys[];
boolean keyCodes[];

void initializeKeys() {
  keys = new boolean[255];
  keyCodes = new boolean[255];
  for (int i = 0; i < 255; i ++) {
    keys[i] = false;
    keyCodes[i] = false;
  }
}

void keyReleased() {
  if (key == CODED && keyCode >=0 && keyCode < 255) 
    keyCodes[keyCode] = false;
  
  else if (key >= 0 && key < 255) 
    keys[key] = false;
}

void keyPressed() {
 
  if (key == CODED && keyCode >=0 && keyCode < 255) 
    keyCodes[keyCode] = true;
    
  if (key >= 0 && key < 255) 
    keys[key] = true;
  
  if (key == CODED && keyCode == UP) {
      if(keys['a']) thres[0] += 1;
      if(keys['s']) thres[1] += 1;
      if(keys['d']) thres[2] += 1;
  } 
  else if (key == CODED &&  keyCode == DOWN) {
      if(keys['a']) thres[0] -= 1;
      if(keys['s']) thres[1] -= 1;
      if(keys['d']) thres[2] -= 1;
    } 
   if (key == 's') {
     saveSetting("thres_0", thres[0]);
     saveSetting("thres_1", thres[1]);
     saveSetting("thres_2", thres[2]);
     println("Save settings... ");
   }
    
   if(key >= '0' && key <= '9'){
       if(keys['b']) sendValue(1, int(key - '0'));
       if(keys['g']) sendValue(2, int(key - '0'));
       if(keys['j']) sendValue(3, int(key - '0'));
   
 }
}


