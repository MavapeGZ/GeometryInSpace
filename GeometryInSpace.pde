// State: (Accesible from ...)
// case 0: Shows the main menu with the five avaliable shapes (1,3)
// case 1: Shows the options menu with the two avaliable options (0,2)
// case 2: Shows the color menu with four options (1)
// case 3: Starts the game with the corresponding shape and option (2)

int state = 0;
String mainMenu = ""; // Main menu --> Cube / Cylinder / Sphere / Pyramid / Cone
String typeMenu = ""; // Type menu --> Wireframe / Volumetric
String colorMenu = ""; // Color menu --> White / Red / Green / Blue
ArrayList<Button> buttons = new ArrayList<Button>();

float xTranslate = 0;
float yTranslate = 0;
float zTranslate = 0; // Three vars for the rotation of the shapes
float rotationSpeed = 0.01; // Rotation speed when key pressed
float accumulatedRotation = 0; // Accumulated rotation angle
float initialRotationX = 5.5*PI / 6; // This is a variable for the cylinder, to see it from a better angle

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false; // boolean vars to help the rotation to be smooth

boolean ctrl = true; // To help us with the behaviour of the controls text

void setup() {
  fullScreen(P3D);
  background(0);
  createMainMenu();
}

void draw() {
  background(0);
  noStroke();
  switch(state) {
  case 0: // Initial state (main menu)
    displayButtons();
    textSize(50);
    fill(255);
    text("Geometry in space", width / 2, height / 2 - 400);
    break;
  case 1: // Screen with 2 buttons (type menu)
    displayShapeName(mainMenu);
    break;
  case 2: // Screen with 4 buttons (color menu)
    displayShapeNameType(mainMenu, typeMenu);
    break;
  case 3: // In-game state
    displayShape();
    break;
  }
}

void createMainMenu() {
  buttons.clear();
  int buttonWidth = 200;
  int buttonHeight = 75;
  int spacing = 40;
  for (int i = 0; i < 5; i++) {
    buttons.add(new Button(width / 2, height / 2 - (5 * buttonHeight + 4 * spacing) / 2 + i * (buttonHeight + spacing), buttonWidth, buttonHeight, "", 0)); // No label because it's going to be setted down here
    switch(i) {
    case 0:
      buttons.get(i).label = "Cube";
      break;

    case 1:
      buttons.get(i).label = "Cylinder";
      break;

    case 2:
      buttons.get(i).label = "Sphere";
      break;

    case 3:
      buttons.get(i).label = "Pyramid";
      break;

    case 4:
      buttons.get(i).label = "Cone";
      break;
    }
  }
  buttons.add(new Button(width - 150, height - 75, buttonWidth, buttonHeight, "Quit", 99));
}

void createTypeMenu() {
  buttons.clear(); // Function to clear the pixels
  int buttonWidth = 200;
  int buttonHeight = 75;
  int spacing = 50;
  for (int i = 0; i < 2; i++) {
    buttons.add(new Button(width / 2, height / 2 - buttonHeight / 2 + i * (buttonHeight + spacing), buttonWidth, buttonHeight, "", 1));
    switch(i) {
    case 0:
      buttons.get(i).label = "Wireframe";
      break;

    case 1:
      buttons.get(i).label = "Volumetric";
      break;
    }
  }

  buttons.add(new Button(width - 150, height - 75, buttonWidth, buttonHeight, "Back", 98));
}

void createColorMenu() {
  buttons.clear();
  int buttonWidth = 200;
  int buttonHeight = 75;
  int spacing = 40;
  for (int i = 0; i < 4; i++) {
    buttons.add(new Button(width / 2, height / 2 - 2 * (buttonHeight + spacing) + buttonHeight + i * (buttonHeight + spacing), buttonWidth, buttonHeight, "", 2));
    switch(i) {
    case 0:
      buttons.get(i).label = "White";
      break;

    case 1:
      buttons.get(i).label = "Red";
      break;

    case 2:
      buttons.get(i).label = "Green";
      break;

    case 3:
      buttons.get(i).label = "Blue";
      break;
    }
  }

  buttons.add(new Button(width - 150, height - 75, buttonWidth, buttonHeight, "Back", 98));
}

void displayButtons() { // Display of the buttons
  for (Button b : buttons) {
    b.display();
  }
}

void displayShapeName(String mainMenu) { // Text showing only the selected shape on typeMenu
  textAlign(CENTER);
  textSize(30);
  fill(255);
  text("Selected shape: " + mainMenu, width / 2, height / 2 - 150);
  displayButtons();
}

void displayShapeNameType(String mainMenu, String typeMenu) { // Text showing shape and type selected on colorMenu 
  textAlign(CENTER);
  textSize(30);
  fill(255);
  text("Selected shape: " + typeMenu + " " + mainMenu, width / 2, height / 2 - 250);
  displayButtons();
}

void displayFinalShapeName() { // Text showing all the choices made, so the user knows what is beeing showed on the screen
  textAlign(CENTER);
  textSize(30);
  fill(255);
  text("Current shape: " + colorMenu + " " + typeMenu + " " + mainMenu, width / 2, height / 2 - 450);
  for (Button b : buttons) {
    if (b.label.equals("Main Menu")) {
      b.display();
    }
  }
  if(showControlsText(ctrl)){ // If the user didn't touched any movement key
    textSize(50);
    fill(255);
    text("Press the arrow keys to move around the geometric shape", width / 2, height / 2 + 200); // Controls explanation text
  }
}

void displayShape() {
  
  displayFinalShapeName(); // Name of the shape
  setupShape(); // Type and color
  lights(); // Visual
  translate(width/2 + xTranslate, height/2 + yTranslate, zTranslate);

  // Apply the accumulated rotation
  rotateY(accumulatedRotation);
  
  switch(mainMenu) {
  case "Cube":
    box(200, 200, 200);
    break;

  case "Cylinder":
    // Apply an initial rotation in the X axis to see the top side of the cylinder
    rotateX(initialRotationX);
    drawCylinder(100, 200);

    break;

  case "Sphere":
    sphere(100); 
    break;

  case "Pyramid":
    drawPyramid(200, 200);
    break;

  case "Cone":
    drawCone(100, 200);
    break;
  }
  if (upPressed) {
    zTranslate += 5;
    zTranslate = constrain(zTranslate, -500, 925);
  }
  if (downPressed) {
    zTranslate -= 5;
    zTranslate = constrain(zTranslate, -500, 925);
  }

  // Rotate the cube continuously if the LEFT or RIGHT keys are pressed
  if (rightPressed) {
    accumulatedRotation -= rotationSpeed;
  }
  if (leftPressed) {
    accumulatedRotation += rotationSpeed;
  }
}

void setupShape() {
  switch(colorMenu) {
  case "White":
    if (typeMenu == "Wireframe") {
      stroke(255);
      noFill();
    } else if (typeMenu == "Volumetric") {
      fill(255);
      noStroke();
    }
    break;

  case "Red":
    if (typeMenu == "Wireframe") {
      stroke(255, 0, 0);
      noFill();
    } else if (typeMenu == "Volumetric") {
      fill(255, 0, 0);
      noStroke();
    }
    break;

  case "Green":
    if (typeMenu == "Wireframe") {
      stroke(0, 255, 0);
      noFill();
    } else if (typeMenu == "Volumetric") {
      fill(0, 255, 0);
      noStroke();
    }
    break;

  case "Blue":
    if (typeMenu == "Wireframe") {
      stroke(0, 0, 255);
      noFill();
    } else if (typeMenu == "Volumetric") {
      fill(0, 0, 255);
      noStroke();
    }
    break;
  }
}

void drawCylinder(float r, float h) {
  int sides = 50; // N sides to aproximate the cylinder
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    float angle = TWO_PI / sides * i;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, -h / 2, z); // Adjustment to center the cylinder
    vertex(x, h / 2, z); 
  }
  endShape();

  // Tapas del cilindro
  for (int j = 0; j < 2; j++) {
    float y = (j - 0.5) * h; 
    beginShape(TRIANGLE_FAN);
    vertex(0, y, 0);
    for (int i = 0; i <= sides; i++) {
      float angle = TWO_PI / sides * i;
      float x = cos(angle) * r;
      float z = sin(angle) * r;
      vertex(x, y, z);
    }
    endShape();
  }
}

void drawPyramid(float base, float h) {
  float halfBase = base / 2;
  
  // Definir los vértices de la pirámide
  PVector v0 = new PVector(-halfBase,  halfBase,  halfBase); // Bottom left
  PVector v1 = new PVector( halfBase,  halfBase,  halfBase); // Bottom right
  PVector v2 = new PVector( halfBase,  halfBase, -halfBase); // Upper right
  PVector v3 = new PVector(-halfBase,  halfBase, -halfBase); // Upper left
  PVector v4 = new PVector(0, -h, 0); // Top
  
  // Pyramid base
  beginShape();
  vertex(v0.x, v0.y, v0.z);
  vertex(v1.x, v1.y, v1.z);
  vertex(v2.x, v2.y, v2.z);
  vertex(v3.x, v3.y, v3.z);
  endShape(CLOSE);
  
  // Pyramid faces
  beginShape(TRIANGLES);
  // 1
  vertex(v0.x, v0.y, v0.z);
  vertex(v1.x, v1.y, v1.z);
  vertex(v4.x, v4.y, v4.z);
  // 2
  vertex(v1.x, v1.y, v1.z);
  vertex(v2.x, v2.y, v2.z);
  vertex(v4.x, v4.y, v4.z);
  // 3
  vertex(v2.x, v2.y, v2.z);
  vertex(v3.x, v3.y, v3.z);
  vertex(v4.x, v4.y, v4.z);
  // 4
  vertex(v3.x, v3.y, v3.z);
  vertex(v0.x, v0.y, v0.z);
  vertex(v4.x, v4.y, v4.z);
  endShape();
}

void drawCone(float r, float h) {
  int sides = 50; // N sides to aproximate the cone
  
  // Cone base
  beginShape();
  for (int i = 0; i <= sides; i++) {
    float angle = TWO_PI / sides * i;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, h / 2, z); // Base centered
  }
  endShape(CLOSE);
  
  // Cone faces
  beginShape(TRIANGLE_FAN);
  vertex(0, -h / 2, 0); 
  for (int i = 0; i <= sides; i++) {
    float angle = TWO_PI / sides * i;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, h / 2, z);
  }
  endShape(CLOSE);
}

void resetCoordinateVars() {
  xTranslate = 0;
  yTranslate = 0;
  zTranslate = 0;
  accumulatedRotation = 0;
  initialRotationX = 5.5*PI / 6;
  ctrl = true;
}

boolean showControlsText(boolean control){
  boolean toRet = false;
  if((xTranslate == 0 && yTranslate == 0 && zTranslate == 0 && accumulatedRotation == 0) && control){ // If the user touches any key, return false, so the instructions will dissapear
    toRet = true;
  }
  
  return toRet;
}

void mousePressed() {
  for (Button b : buttons) {
    if (b.isMouseOver()) {
      if (b.action == 99) {
        exit();
      } else if (b.action == 98) {
        if (state == 3) {
          state = 0;
          createMainMenu();
          resetCoordinateVars(); // Reset the vars for the next shape when going back to the main menu
        } else {
          state--;
          if (state == 0) {
            createMainMenu();
          } else if (state == 1) {
            createTypeMenu();
          } else if (state == 2) {
            createColorMenu();
          }
        }
      } else {
        if (state == 0) {
          mainMenu = b.label;
          state++;
          createTypeMenu();
        } else if (state == 1) {
          typeMenu = b.label;
          state++;
          createColorMenu();
        } else if (state == 2) {
          colorMenu = b.label;
          state++;
          buttons.clear();
          buttons.add(new Button(width - 150, height - 75, 200, 75, "Main Menu", 98));
        }
      }
      break;
    }
  }
}

void keyPressed() {
  if (keyCode == UP) {
    upPressed = true;    
  } else if (keyCode == DOWN) {
    downPressed = true;
  }
  // Verify the press on LEFT and RIGTH arrows
  if (keyCode == LEFT) {
    leftPressed = true;
  } else if (keyCode == RIGHT) {
    rightPressed = true;
  }  
  ctrl = false;
}

void keyReleased() {
  if (keyCode == UP) {
    upPressed = false;
  }
  if (keyCode == DOWN) {
    downPressed = false;
  }
  // Stop the accumulated rotation when that keys are released
  if (keyCode == LEFT || keyCode == RIGHT) {
    leftPressed = false;
    rightPressed = false;
  }
}

// Button class. This class is created due to the complex behaviour of the button
class Button {
  float x, y, w, h; // x and y coordinates and a width and height
  String label; // label with the text inside the button
  int action; // 0,1,2,3 for states; 98 for BACK button; 99 for QUIT button

  Button(float x, float y, float w, float h, String label, int action) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.action = action;
  }

  void display() { // Method to be able to show the button on the screen
    rectMode(CENTER);
    fill(200);
    rect(x, y, w, h);
    fill(0);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(label, x, y);
  }

  boolean isMouseOver() { // Function to check if the mouse is over the button when clicked
    return mouseX > x - w / 2 && mouseX < x + w / 2 && mouseY > y - h / 2 && mouseY < y + h / 2;
  }
}
