
class FourierSeries {
  
  private double t = 0, speed = 0.001;
  
  private ArrayList<Wave> list;
  private ArrayList<Vector> vertices;
  private Vector[] path;
  
  private int vectorCount = 20;
  
  public FourierSeries(ArrayList<Vector> vertices) {
    this.vertices = vertices;
    
    int n = 1000;
    int accuracy = 1000;
    
    list = new ArrayList();
    addPathPoint(0, accuracy);
    for (int i = 1; i <= n/2; i++) {
      addPathPoint(i, accuracy);
      addPathPoint(-i, accuracy);
    }
    
    path = getPath(1000);
  }
  
  public void changeVectorCount(int n) {
    float change = n * (vectorCount / 8.0);
    if (Math.abs(change) < 1) change = change >= 0 ? 1 : -1;
    
    vectorCount += change;
    vectorCount = Math.max(Math.min(this.list.size(), vectorCount), 2);
    path = getPath(this.path.length);
  }
  
  public int getVectorCount() {
    return this.vectorCount;
  }
  
  private void addPathPoint(int n, int accuracy) {
      Vector avg = new Vector(0, 0);
      for (int j = 0; j < accuracy; j++) {
        
        double t = (double) j / accuracy;
        Vector vec = f(t);
        double a = -n*2*Math.PI*t;
        vec = new Vector(vec.x*Math.cos(a) - vec.y*Math.sin(a), vec.x*Math.sin(a) + vec.y*Math.cos(a));
        
        avg.x += vec.x;
        avg.y += vec.y;
      }
      avg.x /= accuracy;
      avg.y /= accuracy;
      
      list.add(new Wave(n, Math.sqrt(avg.x*avg.x + avg.y*avg.y), Math.atan2(avg.y, avg.x)));
  }
  
  Vector[] getPath(int size) {
    Vector[] arr = new Vector[size];
    for (int i = 0; i < size; i++) {
      arr[i] = waveFunction((double) i / size, false);
    }
    return arr;
  }
  
  private float scale = 100, targetScale = 100;
  private Vector center = new Vector(0, 0);
  
  void update() {
    pushMatrix();
    scale -= (scale - targetScale) * 0.5;
    
    translate(width / 2, height / 2);
    Vector vec = waveFunction(t, true);
    
    double m = (scale - 100) / 100;
    if (m > 1) m = 1;
    center.x = vec.x;
    center.y = vec.y;
    
    translate((float) -center.x * scale, (float) -center.y * scale);
    drawFunction(path);
    
    noStroke();
    fill(255, 0, 0);
    ellipse((float) vec.x *scale, (float) vec.y *scale, 10, 10);
    popMatrix();
    
    fill(255);
    noStroke();
    textSize(25);
    text("Current vector count: " + this.vectorCount, width / 2, 40);
    
    t += speed;
    if (t >= 1) t = 0;
  }
  
  Vector waveFunction(double x, boolean draw) {
    x *= Math.PI * 2;
    Vector sum = new Vector(0, 0);
    
    if (draw) {
      stroke(255);
      strokeWeight(2);
      noFill();
      beginShape();
    }
      
    for (int i = vectorCount -1; i >= 0; i--) {
      Vector next = new Vector(
        sum.x + Math.cos(x * list.get(i).frequency + list.get(i).offset) * list.get(i).scale,
        sum.y + Math.sin(x * list.get(i).frequency + list.get(i).offset) * list.get(i).scale);
      
      if (draw) {
        float radius = dist((float) sum.x, (float) sum.y, (float) next.x, (float) next.y) * scale * 2;
        strokeWeight(1);
        stroke(255, 25);
        ellipse((float) -next.x * scale, (float) -next.y * scale, radius, radius);
        
        stroke(255);
        strokeWeight(2);
        line((float) -sum.x * scale, (float) -sum.y * scale, (float) -next.x * scale, (float) -next.y * scale);
      }
      
      sum.x = next.x;
      sum.y = next.y;
    }
    
    if (draw) endShape();
    
    return sum;
  }
  
  void drawFunction(Vector[] func) {
    strokeWeight(2);
    stroke(255, 255, 0);
    noFill();
    beginShape();
    
    for (int i = 0; i < func.length; i++) {
      vertex((float) func[i].x *scale, (float) func[i].y *scale);
    }
    endShape(CLOSE);
    
    stroke(255, 255, 0, 50);
    strokeWeight(2);
    beginShape();
    
    for (Vector vec : this.vertices) {
      vertex((float) vec.x *scale, (float) vec.y *scale);
    }
    endShape(CLOSE);
  }
  
  Vector f(double x) {
    x %= 1.0;
    int index = (int) (x * vertices.size());
    double y = 1 - ((x * vertices.size()) - (int) (x * vertices.size()));
    Vector v1 = vertices.get(index);
    Vector v2 = vertices.get((index + 1) % vertices.size());
    return new Vector((v1.x - v2.x) * y + v2.x, (v1.y - v2.y) * y + v2.y);
  }
  
  class Wave {
    double frequency, scale, offset;
    public Wave(double frequency, double scale, double offset) {
      this.frequency = frequency;
      this.scale = scale;
      this.offset = offset;
    }
  }
  
  void scroll(int count, boolean ctrl) {
    if (ctrl) {
      speed /= count / 10.0 +1;
      return;
    }
    targetScale /= pow(1.3, count);
  }
  
  void key() {
    if (keyCode == UP) {
      speed *= 1.3;
    }
    if (keyCode == DOWN) {
      speed /= 1.3;
    }
  }
}
