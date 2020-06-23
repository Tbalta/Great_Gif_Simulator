class Sprite {
  PVector pos;
  ArrayList<PImage> sprites;
  int offset;
  int time = 0;
  public int nbFrame;


  public Sprite(PVector pos, ArrayList<PImage> sprites, int offset) {
    this.pos = pos;
    this.sprites = sprites;
    this.offset = offset;
    nbFrame = sprites.size();
  }

  public void render(int time) {
    image(this.sprites.get((time + this.offset) % this.sprites.size()), this.pos.x, this.pos.y);
    this.time = time;
  }
  
  

  public void move(PVector pos) {
    this.pos = pos;
  }

  public boolean intersect(PVector pos) {

    final float x = map(float(this.sprites.get((this.time + this.offset) % this.sprites.size()).width), 0f, 150f, 20f, 40f);
    final float y = map(float(this.sprites.get((this.time + this.offset) % this.sprites.size()).height), 0, 150, 20, 40);

    return (pos.x > this.pos.x - x && pos.x < this.pos.x + x)
      && (pos.y > this.pos.y - y && pos.y < this.pos.y + y);
  }

  public void highlight() {
    tint(105, 0, 0);
    this.render(this.time);
    noTint();
  }
}
