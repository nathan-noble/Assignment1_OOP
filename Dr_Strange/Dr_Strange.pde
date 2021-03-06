/*
 Author:   Jonathan Noble - C15487922
 Year:     DT282/2
 Program:  Assignment1_OOP (Doctor Strange Portal UI)
 Due Date: 29/11/2016
 */

// I am declaring everything in order of sequence and priority

//Declare Opening intro
Intro intro;
PFont font;

//Declaring the sounds
import ddf.minim.*;
Minim minim;
AudioPlayer player, bonjour, america, cantonese, portal_sound, alien;

//Declaring Starfield background and the portal
BackGround[] bg = new BackGround[500];
BG_Objects[] bgObjects = new BG_Objects[1];

//Declaring the Portal and the nodes
Portal open_port;
createPortal createPort;
ArrayList<Nodes> nodes = new ArrayList<Nodes>();
boolean exec = false;
float count = 0;
float nodeX, nodeY;
float nodeSize1, nodeSize2;

//Declaring the images of the numbers 
PImage numbers[] = new PImage[5];

//Declaring the particles
Particles[] part = new Particles[30];

//Declaring the places inside the Portal
ArrayList<SolarSystem> system = new ArrayList <SolarSystem>();
int lastTime = 0;
StatueOfLiberty sol;
EiffelTower eiffel;
Buddha bud;
GameOfLife gol;

void setup() {
  size(1250, 700);
  colorMode(HSB);
  smooth();

  //Initializing the very quick intro
  intro = new Intro();
  intro.display();

  //Initializing the font
  font = loadFont("felix.vlw");

  //Initializing all the sounds
  minim = new Minim(this);
  player = minim.loadFile("music.mp3");  
  bonjour = minim.loadFile("bonjour.mp3"); 
  america = minim.loadFile("america.mp3"); 
  cantonese = minim.loadFile("cantonese.mp3"); 
  alien = minim.loadFile("alien.mp3"); 
  portal_sound = minim.loadFile("portal_sound.mp3"); 
  player.loop();

  //Initializing the portal and it's magic wand
  open_port = new Portal();
  createPort = new createPortal();


  //Initializing the diamond nodes and the table
  Table table = loadTable("skills.csv", "header");
  for (TableRow row : table.rows())
  {
    Nodes node = new Nodes(row);//open_port);
    nodes.add(node);
    nodeX = node.locNodes.x;
    nodeY = node.locNodes.y;
    nodeSize1 = node.radius1;
    nodeSize2 = node.radius2;
  } 


  //Initializing the images the of the numbers
  for (int i = 0; i < numbers.length; i++)
  {
    numbers[i] = loadImage("num" + i + ".png");
  }

  //Initializing the Particles and it's color around the portal
  for (int i=0; i<part.length; i++) {
    part[i]=new Particles();
  }

  //Initializing the starfield background
  for (int i = 0; i < bg.length; i++) {
    bg[i] = new BackGround(open_port, 
      random(-width/2, width/2), random(-height/2, height/2), random(width/2) );
  }

  //Initializing the bgObjects flying around the starfield
  for (int i = 0; i < bgObjects.length; i++) {
    bgObjects[i] = new BG_Objects(open_port, 
      random(width/2, width/2), random(height/2, height/2), random(width/2));
  }


  //Places inside the Portal initialized here
  SolarSystem sun = new SolarSystem(open_port, 0, 0.01, 0, "sun.png");
  SolarSystem earth = new SolarSystem(open_port, 310, 1/2, 0.05, "earth.png");
  SolarSystem moon = new SolarSystem(open_port, 120, 200, 0.65, "moon.png");
  //Adding the children of the ArrayList
  system.add(sun);
  sun.add(earth);
  earth.add(moon);
  lastTime = millis();


  sol = new StatueOfLiberty(open_port, -50, -80);
  eiffel = new EiffelTower(open_port, -103, -90);
  bud = new Buddha(open_port, -150, -130);
  gol = new GameOfLife(open_port);


  println("You have unlocked these abilities!");
  //Display the abilities unlocked
  for (Nodes node : nodes)
  { 
    println(node);
  }
}


void draw() 
{  
  background(random(mouseX/6, 2 * this.open_port.radius % 255), 200, 50);
  float delta = (millis() - lastTime) / 1000.0f;

  for (BackGround backg : bg) {
    backg.update();
    backg.display();
  }
  for (BG_Objects bgObj : bgObjects) {
    bgObj.update();
    bgObj.display();
  }

  createPort.display();

  nodesConnected();

  for (Nodes node : nodes) {
    node.display();

    float x = node.location.x;
    float y = node.location.y;

    if (mouseX >= x && mouseX <= x + width/2 && 
      mouseY >= y && mouseY <= y + height/2) {
      textAlign(LEFT, CENTER);
      fill(255);
      textFont(font);
      text(node.abilityName, x + 35, y - 2);
    }

    if (exec) //if all nodes are connected/hovered == true
    {
      count++;
    }
  }
  //Once counter detects that the nodes has been hit, then it will execute the portal
  if (count > 2) {
    if (mousePressed == true) {
      open_port.display();
      portal_sound.play();

      translate(width/2, height/2);
      if (keyPressed) 
      {
        if (key == '1')
        {
          pushMatrix();
          for (SolarSystem solarS : system) {
            solarS.display();
            solarS.update(delta);
          }
          popMatrix();
          lastTime = millis();
          showNumbers();
        }

        if (key == '2')
        {
          sol.display();
          america.play();
          showNumbers();
        }
        if (key == '3')
        {
          eiffel.display();
          bonjour.play();
          showNumbers();
        }

        if (key == '4')
        {
          bud.display();
          cantonese.play();
          showNumbers();
        }

        if (key == '5')
        {
          gol.generate();
          gol.display();
          alien.play();
          showNumbers();
        }
      }

      for (Particles par : part) {
        par.update();
        par.display();
      }
    }
  }    // end mousePressed = true
}// end draw function

void nodesConnected() {
  if (overNodes (nodeX, nodeY, nodeSize1, nodeSize2) ) {
    exec = true;
  } else {
    exec = false;
  }
}

boolean overNodes(float x, float y, float radius1, float radius2) 
{
  float disX = x - mouseX;
  float disY = y - mouseY;
  //If Square root of the squared disX is lesser than half of radius is true then return true
  if (sqrt(sq(disX) + sq(disY)) < radius1/2 && sqrt(sq(disX) + sq(disY))< radius2/2 ) {
    return true;
  } else {
    return false;
  }
}

void showNumbers() {
  float imgPosX = -width/2.05;
  float imgPosY = -height/2.2;
  float imgSizeX = 250;
  float imgSizeY = 300;

  if (keyPressed)
  { 
    if (key == '1')
      image(numbers[0], imgPosX, imgPosY, imgSizeX, imgSizeY);

    if (key == '2')
      image(numbers[1], imgPosX, imgPosY, imgSizeX, imgSizeY);

    if (key == '3')
      image(numbers[2], imgPosX, imgPosY, imgSizeX, imgSizeY);

    if (key == '4')
      image(numbers[3], imgPosX, imgPosY, imgSizeX, imgSizeY);

    if (key == '5')
      image(numbers[4], imgPosX, imgPosY, imgSizeX, imgSizeY);
  }
} // end showNumbers function