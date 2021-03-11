
FourierSeries drawingMachine;

String[] chars = new String[] {"m", "l", "h", "v", "c", "s", "q", "t", "a", "z"};

String[] paths;
Button[] buttons;

void setup() {
  frameRate(50);
  size(1250, 900);
  
  File[] files = listFiles("paths/");
  paths = new String[files.length];
  for (int i = 0; i < files.length; i++) {
    this.paths[i] = files[i].getName();
  }
  
  buttons = new Button[paths.length];
  for (int i = 0; i < paths.length; i++) {
    buttons[i] = new Button(paths[i], 10, 10 + 60 * i, 200, 50) {
      public void onClick() {
        println(this.text);
        drawingMachine = new FourierSeries(createVertexArray(this.text));
      }
    };
  }
  
  printArray(paths);
  
  noSmooth();
  ellipseMode(CENTER);
  clear();
  
  drawingMachine = new FourierSeries(createVertexArray(paths[0]));
}

ArrayList<Vector> createVertexArray(String src) {
  ArrayList<Vector> vertecies = new ArrayList();
  for (String line : loadStrings("paths/"+ src)) {
    vertecies.add(new Vector(line));
  }
  return vertecies;
}

void draw() {
  clear();
  
  if (drawingMachine != null) drawingMachine.update();

  fill(255);
  noStroke();
  textSize(25);
  text("Zoom: scroll\nChange speed: CRTL + scroll\nChange vector count: up and down arrow", 5, height - 100);
  
  for (Button b : buttons) {
    b.show();
  }
  
}

boolean ctrl = false;

void mouseWheel(MouseEvent e) {
  if (drawingMachine != null) drawingMachine.scroll(e.getCount(), ctrl);
  println(ctrl);
}

void keyPressed() {
  if (keyCode == CONTROL) ctrl = true;
  if (keyCode == UP) drawingMachine.changeVectorCount(1);
  if (keyCode == DOWN) drawingMachine.changeVectorCount(-1);
}
void keyReleased() { if (keyCode == CONTROL) ctrl = false; }

class Vector {
  double x, y;
  
  public Vector(double x, double y) {
    this.x = x;
    this.y = y;
  }
  
  public Vector(String str) {
    try {
      String[] splitted = str.split(",");
      this.x = Double.parseDouble(splitted[0]);
      this.y = Double.parseDouble(splitted[1]);
    } catch (Exception err) {
      this.x = 0;
      this.y = 0;
    }
  }
}
