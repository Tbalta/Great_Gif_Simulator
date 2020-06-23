ArrayList<Sprite> spriteList = new ArrayList();
enum Mode {
  DELETE, EDIT, MOVE
};


ArrayList<ArrayList<PImage>> availableSprite = new ArrayList();

Mode currentState = Mode.EDIT;

int counter = 0;

Sprite current;
int index = 0;
int offset = -1;
Sprite selectedSprite = null;
boolean save = false;
int speed = 10;
int MAX_FRAME = 3;
int frameNumber = 0;
void setup() {
  getImages(sketchPath() + "\\image");
 //<>//
  print(availableSprite.size());
  current = new Sprite(new PVector(0, 0), availableSprite.get(index), 0);
  //<>//
  size(900, 400);
  frameRate(60);
  imageMode(CENTER);
}

void getImages(String filePath){
  print(sketchPath());
    File file = new File(filePath);
    String paths[] = file.list();
    for(String path: paths){
      ArrayList<PImage> images = listFileNames(filePath + "\\"+path);
      if (images != null)
        availableSprite.add(images);
    }
  
}

ArrayList<PImage> listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    ArrayList<PImage> toReturn = new ArrayList();
    for (String fileName : names){
      toReturn.add(loadImage(dir +"\\"+fileName));
    }
    return toReturn;
  } else {
    // If it's not a directory
    return null;
  }
}


void draw() {
  background(51);

  for (Sprite sprite : spriteList) {
    sprite.render(floor(counter / speed));
  }

  if (currentState == Mode.EDIT) {
    
    if (!save){
    current.move(new PVector(mouseX, mouseY));
    current.render(floor(counter / speed));
    } else {
    save("ouput/canvas#"+counter+".png");
    saveFrame("output/gif-"+nf(counter, 3)+".png");
    save = counter < (frameNumber * speed) -1;
    }
 
    counter++;
  } else {
    int i = spriteList.size() - 1;
    while (i >= 0 && !spriteList.get(i).intersect(new PVector(mouseX, mouseY))) {
      i--;
    }
    if (i >= 0) {
      spriteList.get(i).highlight();
    }
  }




}

void startRecord(){
  save = true;
  counter = 0;
  frameNumber = getFrameNumber();
}

void  mousePressed() {
  if (currentState == Mode.MOVE) {
    selectedSprite = getIntersectingSprite();
  }
}

int getFrameNumber(){
  int sum = 1;
    for (Sprite sprite : spriteList) {
      if (sum % sprite.nbFrame != 0){
        sum *= sprite.nbFrame;
      }
  }
  print(sum);
  return sum;

}

//void mouseClicked() {
//  print("pressed");
//  if (currentState == Mode.DELETE) {
//    removeSprite();
//  } else if (currentState == Mode.EDIT) {
//    int decalage = (offset == -1) ? floor(random(availableSprite.get(index).size())) : offset;  
//    spriteList.add(new Sprite(new PVector(mouseX, mouseY), availableSprite.get(index), decalage));
//  }
//}

void mouseDragged() {
  if (currentState == Mode.MOVE && selectedSprite != null) {
    selectedSprite.move(new PVector(mouseX, mouseY));
  }
}

void removeSprite() {
  for (int i = spriteList.size() - 1; i >= 0; i--) {
    if (spriteList.get(i).intersect(new PVector(mouseX, mouseY))) {
      spriteList.remove(i);
      return;
    }
  }
}

Sprite getIntersectingSprite() {
  for (int i = spriteList.size() - 1; i >= 0; i--) {
    if (spriteList.get(i).intersect(new PVector(mouseX, mouseY))) {
      return spriteList.get(i);

    }
  }
  return null;
}


void keyPressed() {
  if (keyCode == 32) {
    index = (index + 1) % availableSprite.size();
    current = new Sprite(new PVector(0, 0), availableSprite.get(index), 0);
  } else if (keyCode == DELETE) {
    currentState = (currentState != Mode.DELETE) ? Mode.DELETE : Mode.EDIT;
  } else if (keyCode == UP) {
    offset++;
    print(offset);
  } else if (keyCode == DOWN) {
    if (offset > -1) offset--;
    print(offset);
  } else if (keyCode == 77) {
    selectedSprite = null;
    currentState = (currentState != Mode.MOVE) ? Mode.MOVE : Mode.EDIT;
  } else if (keyCode == ENTER){
    startRecord();
  } else  if (keyCode == 33){
    speed++;
    print(speed);
  } else if (keyCode == 34){
    if (speed != 1)
      speed --;
     print(speed);
  }
}

void mouseReleased() {
    if (currentState == Mode.DELETE) {
    removeSprite();
  } else if (currentState == Mode.EDIT) {
    int decalage = (offset == -1) ? floor(random(availableSprite.get(index).size())) : offset;  
    spriteList.add(new Sprite(new PVector(mouseX, mouseY), availableSprite.get(index), decalage));
  }
  if (selectedSprite != null)
    selectedSprite = null;
}
