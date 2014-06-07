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
      if(keys['g']) gain += 1;
      if(keys['d']) decay += 0.005;
  } 
  else if (key == CODED &&  keyCode == DOWN) {
      if(keys['g']) gain -= 1;
      if(keys['d']) decay -= 0.005;
    } 
   if (key == 's') {
     saveSetting("decay", decay);
     saveSetting("gain", gain);
     println("Save settings... ");
   }
    
   if(key >= '0' && key <= '9')
       sendValue(int(key - '0') - 1);
    
}


