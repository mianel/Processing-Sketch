class GraphBar {
  int startPosX;
  int startPosY;

  int lengthX;
  int lengthY;

  //Label
  String label;
  String labelVals;
  float labelPosX;
  float labelPosY;
  int fontLength;

  float maxLengthY;
  float maxLengthX;
  float midLevel;

  Rect rectSignal;
  Rect rectLabel;

  Slider slider;

  CopyOnWriteArrayList queueValues;

  float threshold = 1.0;
  float dim = 6.5;
  int   stepX = 4;
  int   stepDivision;

  color fontColor = color(150);

  int type;

  GraphBar(String  name, int drawPosX, int drawPosY, int lengthX, int lengthY, int fontLength, int type) {
    queueValues = new CopyOnWriteArrayList<Float>();
    this.startPosX = drawPosX;
    this.startPosY = drawPosY;
    this.lengthX   = lengthX;
    this.lengthY   = lengthY;

    stepDivision = ceil((float)lengthX / (float)stepX);

    this.type = type;
    if (type == 0) {
      float high =  random(50.0);
      for (int i = 0; i <= stepDivision; i++) {
        if (i %10 == 0)
          queueValues.add( random(50));
        else
          queueValues.add(high);
      }
    }

    if ( type == 3) {
      float high =  255;
      boolean change = false;
      for (int i = 0; i <= stepDivision; i++) {
        queueValues.add(i*1.0);
      }
    }

    if (type == 2 ) {
      float noiseVal = 0.3;
      float noiseInc = 0.027;
      float high =  random(50.0);
      for (int i = 0; i <= stepDivision; i++) {
        queueValues.add( noiseVal);
        noiseVal = noise(noiseInc)*60.0;
        noiseInc += 0.027;
      }
    }


    if (type == 1){
      float high =  50;
      boolean change = false;
      for (int i = 0; i <= stepDivision; i++) {
        if (i % (int)random(10, 14) == 0 )
          change = !change;

        if (change)
          queueValues.add(high);
        else
          queueValues.add(0.0);
      }
    }

    if (type == 4) {
      float noiseVal = 50;
      float noiseInc = 0.027;
      float high =  random(50.0);
      for (int i = 0; i <= stepDivision; i++) {
        queueValues.add( noiseVal);
        noiseVal = noise(noiseInc)*70.0 + random(-2, 2);
        noiseInc += 0.028;
      }
    }


    label = name;

    maxLengthY = log(22000 + 1.0)*dim;
    midLevel   = log(100 + 1.0)*dim;
    labelPosX  = startPosX; 
    labelPosY  = startPosY - maxLengthY - 6;

    maxLengthX = lengthX*stepX - 3;

    rectSignal = new Rect(startPosX, startPosY, lengthX, maxLengthY, midLevel);

    rectLabel  = new Rect(startPosX, startPosY - maxLengthY, lengthX, fontLength*2);
    rectLabel.setAlphaRect(220);

    slider = new Slider(drawPosX, drawPosY + 20, int(lengthX*(stepX/2.0)), 12);

    println("graph vector "+queueValues.size());
  }

  void serFontLength(int a) {
    fontLength = a;
  }

  void setDim(float dim) {
    this.dim = dim;
  }

  void setStepX(int step) {
    stepX = step;
  }

  void draw() {

    rectSignal.drawRectMid();
    rectLabel.drawFullRect();

    noFill();
    stroke(0, 150, 200);

    beginShape();
    for (int i = 0; i < queueValues.size(); i++) {
      float yVal = (Float)queueValues.get(i)*threshold;
      vertex(i*stepX + startPosX, startPosY - yVal - 5);
    }
    endShape();

    drawLabel();

    // slider.draw();
  }

  void drawGradient() {

    rectSignal.drawRectMid();
    rectLabel.drawFullRect();

    noStroke();
    for (int i = 0; i < queueValues.size()-1; i++) {
      float yVal = (Float)queueValues.get(i);
      fill(0, yVal, 100, 150);
      rect(i*stepX + startPosX, startPosY - 64, stepX, 65);
    }

    drawLabel();

    // slider.draw();
  }

  void sliderOff() {
    slider.sliderOff();
  }

  void setSliderRange(float min, float max) {
    slider.setRange(min, max);
  }

  void setFontColor(color fontColor) {
    this.fontColor  = fontColor;
    slider.setFontColor(fontColor);
    rectSignal.setFontColor(fontColor);
  }

  void updateLog(float inValue) {
    queueValues.remove(0);
    queueValues.add(constrain(log(inValue + 1.0)*dim, 0, maxLengthY));
  }

  void updateLinear(float inValue) {
    queueValues.remove(0);
    queueValues.add(constrain(map(inValue, 0, 1, 0, maxLengthY), 0, maxLengthY));
  }

  void setLabel(String labelV) {
    labelVals = labelV;
  }

  void drawLabel() {
    fill(fontColor, 200);
    textFont(font, fontLength);
    text(label, labelPosX + 5, labelPosY);

    text(labelVals, labelPosX + 60, labelPosY);
  }

  void drawLabelRect() {
    line(startPosX, startPosY, startPosX, startPosY + fontLength);
  }

  void setSliderValue(float mX, float mY) {
    slider.setValue(mX, mY);
    threshold =  slider.getSliderValue();
  }
}

