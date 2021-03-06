import processing.sound.*; 



//**************Declaring Variables*************************

SoundFile file, enemyFx, crunchFx, doomFx; 
float start_x, start_y; 
int seconds, score, round = 0, startTime = -1; 
PImage doggy, bg, mazeImg, house, house1, treats, screen1;
PImage[] oldmanList = new PImage[10]; 
PFont healthTxt; 

ArrayList<Treat> treatList = new ArrayList<Treat>();
ArrayList<Treat> treatsEatenList = new ArrayList<Treat>();
ArrayList possiblePlacesH = new ArrayList(); 
ArrayList possiblePlacesV = new ArrayList(); 
boolean isEaten = false, gameOver = true, startGuide = true, gameWon = false, timerStart = false; 


Player p; 
Enemy e, e1, e2, e3, e4;
Treat t;
House h;

//Color of the walls (collision) and grass colors
color wallColor = color(183, 74, 11); 
color grass2 = color(114, 222, 60);  
color grass1 = color(115, 222, 62);
color tuft = color(63, 179, 21);
color spot; 

int treatNumber = 20; //Number of Treats displayed 

//*************************GAME SETUP**********************
void setup()
{ 
  size(1000, 650); //Canvas size
  bg = loadImage("background.png"); //load background image
  // bg.resize(1000, 650);
  bg.loadPixels(); 


  screen1 = loadImage("Screen.png"); 

  //adds possible places for treats into array lists
  for (int i = 0; i < bg.width - 10; i++)
  {
    for (int j = 0; j < bg.height -10; j++)
    {
      if (bg.get(i, j) == grass1 || bg.get(i, j) == grass2 || bg.get(i, j) == tuft)
      {
        possiblePlacesH.add(i);
        possiblePlacesV.add(j);
      }
    }
  }

  //Loading all sound files needed for the game
  file = new SoundFile(this, "Eyeliner.mp3"); 
  file.amp(0.2);
  enemyFx = new SoundFile(this, "grumpy.wav");
  crunchFx = new SoundFile(this, "crunch.mp3"); 
  doomFx = new SoundFile(this, "doom.mp3"); 

  healthTxt = createFont("Arial", 16, true); //Arial, 30 point, anti-aliasing on


  //**************Loading Images used for Player, Treats, and House*********
  doggy = loadImage("pug.png"); //Player Image
  //doggy.resize(35, 40);
  treats = loadImage("bone.png"); //treats Image

  //  treats.resize(25, 25); 
  house = loadImage("dogHouse.png"); 
  // house.resize(90, 90);
  house1 = loadImage("dogHouseDone.png"); 
  // house1.resize(90,90); 

  smooth(); 
  frameRate(60);
  reset();
}

//Allows game to be restarted
void reset()
{
  file.play(); //plays Game music
  startTime = millis();


  p = new Player(); 
  h = new House();
  e = new Enemy(180, 241, 1, 1); 
  e1 = new Enemy(674, 156, 1, 1); 
  e2 = new Enemy(695, 399, 2, 2);
  e3 = new Enemy(484, 464, 1, 3);
  e4 = new Enemy(934, 107, 2, 5); 

  for (int i = 0; i < oldmanList.length; i++)
  {
    if (i % 2 == 1) 
    {
      oldmanList[i] = loadImage("oldMan1.png");
      //oldmanList[i].resize(60, 60);
    } else 
    {
      oldmanList[i] = loadImage("oldMan1flip.png"); 
      // oldmanList[i].resize(60, 60);
    }
  }

  //Scatters treats onto the lawn 
  ArrayList usedSpots = new ArrayList(); 
  treatList.clear();
  treatsEatenList.clear();
  for (int i = 0; i < treatNumber; i++)
  { 
    int anySpot = (int) random(0, possiblePlacesH.size()); 
    if (!usedSpots.contains(anySpot)) {
      usedSpots.add(anySpot); 

      t = new Treat((int)possiblePlacesH.get(anySpot), (int) possiblePlacesV.get(anySpot)); 
      treatList.add(t);
    }
  }
}

//************************PLAY GAME***********************
void draw()
{

  //If game is just beginning
  if (startGuide == true && gameOver == true) 
  {

    background(screen1); 
    textSize(25);
    text("Oh no! All your doggy treats have spilled across\n the old man's lawn!", 50, 250); 
    text("Collect all your treats as quickly as you can while \n avoiding the mean old men. If they find you, \n they'll kick you off the lawn!", 50, 350);   
    text("Press 'TAB' to start the game!", 215, 500);
  }

  //Game lost
  if (gameOver == true && startGuide == false) 
  {
    background(screen1); 

    text("You lost. Guess you really couldn't survive the Pug Life.", 132, 495);
    text("Press 'TAB' to restart.", 200, 400); 
    text("Bones collected: " + p.getScore(), 200, 300);
    text("Time taken: " + p.getTime() + " seconds", 200, 350);
  }

  //If game is won
  if (gameWon == true)
  {
    background(screen1);
    text("YOU WON!", 450, 250);
    text("Press 'TAB' to play again!", 311, 300);
    text("Bones collected: " + p.getScore(), 311, 350);
    text("Time taken: " + p.getTime() + " seconds", 311, 400);
  }

  //If game is started
  if (gameOver == false && startGuide == false) 
  {
    if (round > 0) 
    {
      reset();
      round = 0;
      timerStart = true;
    }
    background(bg); //background
    // image(bg, 500, 325);

    //display player & score
    p.display(); 
    p.displayScore(); 
    p.confineToEdges(); 

    //display enemies
    e.display(); 
    e.move(); 
    e.confineToEdges(); 
    e1.display(); 
    e1.move(); 
    e1.confineToEdges(); 
    e2.display(); 
    e2.move(); 
    e2.confineToEdges(); 
    e3.display(); 
    e3.move(); 
    e3.confineToEdges(); 
    e4.display(); 
    e4.move(); 
    e4.confineToEdges(); 

    //display house
    h.display();
    //timer starts
    if (startTime != -1)
    {
      seconds = (millis() - startTime)/1000;
      text("Timer: " + seconds, 503, 24); 
      p.setTime(seconds);
    }

    //text( "x: " + mouseX + " y: " + mouseY, mouseX, mouseY );
    //displays treats 
    for (int i = 0; i < treatList.size(); i++)
    { 

      treatList.get(i).display(); //doggy treat
    }

    /****Checks if player is in the same spot as a treat.
     it adds a point to the player's score****/
    for (int i = 0; i < treatList.size(); i++) 
    { 
      if (p.getYPos() <= treatList.get(i).getYPos() + 30 && p.getYPos() >= treatList.get(i).getYPos() - 30
        && p.getXPos() <= treatList.get(i).getXPos() + 30 && p.getXPos() >= treatList.get(i).getXPos() - 30 )
      {
        p.setScore(p.getScore() + 1); //Increase player score
        crunchFx.play(); 
        treatsEatenList.add(treatList.get(i)); 
        treatList.remove(i);
      }
    }

    //Checks if player has collected all the treats and is near the house.
    //If yes, then the game is won. 
    if ((treatsEatenList.size() == treatNumber) && p.getYPos() <= h.getY() + 10 && p.getYPos() >= h.getY() - 10
      && p.getXPos() <= h.getX() + 100 && p.getXPos() >= h.getX() - 100 )
    {
      gameWon = true;
      gameOver = true;
    }
  }
}

void keyPressed() 
{
  if (key == TAB)
  {
    file.stop();
    gameOver = true;
    startGuide = true;
    gameWon = false;
    round++;
    enemyFx.stop();
  }

  if (key == TAB && gameOver == true) 
  {
    gameOver = false; 
    startGuide = false;
    gameWon = false;
  }

  //player movement
  p.on_keyPressed();
}