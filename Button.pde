
abstract class Button {
  float x, y, w, h;
  String text;
  
  public Button(String text, float x, float y, float w, float h) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public void show() {
    boolean hover = mouseX > this.x && mouseX < this.x + this.w && mouseY > this.y && mouseY < this.y + this.h;
    if (mousePressed && hover) this.onClick();
    
    fill(hover ? 100 : 0);
    stroke(255);
    rect(this.x, this.y, this.w, this.h);
    
    fill(255);
    noStroke();
    textSize(30);
    text(this.text, x + 5, y + 30, w -10);
  }
  
  abstract void onClick();
}
