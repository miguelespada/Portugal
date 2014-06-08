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
      if(keys['a']) players[0].thres += 1;
      if(keys['s']) players[1].thres += 1;
      if(keys['d']) players[2].thres += 1;
  } 
  else if (key == CODED &&  keyCode == DOWN) {
      if(keys['a']) players[0].thres -= 1;
      if(keys['s']) players[1].thres -= 1;
      if(keys['d']) players[2].thres -= 1;
   } 
   if (key == 's') {
     saveSetting("thres_0", players[0].thres);
     saveSetting("thres_1", players[1].thres);
     saveSetting("thres_2", players[2].thres);
     println("Save settings... ");
   }
    
   if(key >= '0' && key <= '9'){
       if(keys['b']) sendJump(1, int(key - '0'));
       if(keys['g']) sendJump(2, int(key - '0'));
       if(keys['j']) sendJump(3, int(key - '0'));
   }
}


