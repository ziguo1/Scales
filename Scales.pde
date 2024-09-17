void setup() {
  size(512, 512);
}

// shaders would like to know your location
// really just crappy vingette
void shade(int _x, int _y) {
  int centerX = _x / 2, centerY = _y / 2;
  float average = ((float) centerX + (float) centerY) * 1.2;
  
  for (int x = 0; x < _x; x++) {
    for (int y = 0; y < _y; y++) {
      color clr = get(x, y);
      float distFromOrigin = (float) Math.sqrt(
        Math.pow((centerX - x), 2) + Math.pow((centerY - y), 2)
      );
      
      set(x, y, lerpColor(clr, color(0, 0, 0), distFromOrigin / average));
    }
  }
}

// intentional misspelling (sorry!)
void skale(int x, int y, float degRot, float brightnessMod) {
  pushMatrix();
  translate(x, y);
  rotate(radians(degRot));
  stroke(color(153, 232, 135));
  
  {
    fill(color(44 * brightnessMod, 239 * brightnessMod, 62 * brightnessMod));
    beginShape();
    curveVertex(0, 0);
    curveVertex(0, 0);
    curveVertex(20, 50);
    curveVertex(40, 0);
    curveVertex(40, 0);
    endShape();
  }
  
  {
    fill(color(8 * brightnessMod, 222 * brightnessMod, 35 * brightnessMod));
    beginShape();
    curveVertex(0, 0);
    curveVertex(0, 0);
    curveVertex(20, 40);
    curveVertex(40, 0);
    curveVertex(40, 0);
    endShape();
  }
  
  {
    pushMatrix();
    noStroke();
    fill(color(37 * brightnessMod, 190 * brightnessMod, 51 * brightnessMod));
    beginShape();
    curveVertex(0, 0);
    curveVertex(0, 0);
    curveVertex(20, 30);
    curveVertex(40, 0);
    curveVertex(40, 0);
    endShape();
    popMatrix();
  }
  
  beginShape();
  vertex(0, 0);
  vertex(40, 0);
  endShape(CLOSE);
  
  popMatrix();
}

void drawLayer(float brightnessMod, int xOff) {
  for (int x = 0; x < 40; x++) {
    for (int y = 0; y < 40; y++) {          
      skale(x * 40 + xOff, y * 50, 0, brightnessMod);
    }
  }
}

float clamp(float num, float max) {
  boolean isNeg = num > 0 ? false : true;
  if (Math.abs(num) < max) {
    return num;
  } else {
    return max * (isNeg ? -1 : 1);
  } 
}

float targetXOff = 0, targetYOff = 0;
float cameraXOff = 0, cameraYOff = 0;

void draw() {
  background(color(73, 90, 82));
  
  pushMatrix();
  float lerpFactor = 0.1, snapFactor = 0.3;
  targetXOff = clamp(-(mouseX * 0.5), 60);
  targetYOff = clamp(-(mouseY * 0.5), 60);
  
  //if (Math.abs(lerp(cameraXOff, targetXOff, lerpFactor) - cameraXOff) < snapFactor && Math.abs(lerp(cameraYOff, targetYOff, lerpFactor) - cameraYOff) < snapFactor) {
  //  targetXOff = (int) ((Math.random() * 10) * (Math.random() > 0.5 ? -1 : 1));
  //  targetYOff = (int) ((Math.random() * 10) * (Math.random() > 0.5 ? -1 : 1));
  //}
  
  cameraXOff = lerp(cameraXOff, targetXOff, lerpFactor);
  cameraYOff = lerp(cameraYOff, targetYOff, lerpFactor);
  translate(cameraXOff, cameraYOff - 20);
  
  
  drawLayer(0.5F, -10);
  drawLayer(0.5F, +10);
  drawLayer(0.6F, -20);
  drawLayer(1F, 0);
  popMatrix();
   
  shade(512, 512);
}
