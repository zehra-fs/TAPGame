//REMEMBER TO CREATE A GRID W/ Width of Maze Bars, to spread the treats across!!! 

//=========Treat Class=======
class Treat {
  float start_x = random(100,600); 
  float start_y = random(100,600); 
  float x, y; 
  boolean isEaten; 
  Treat()
  {
    x = start_x; 
    y = start_y;
    isEaten = false; 
  }
  
   float getXPos()
  {
    return x;
  }
  
  float getYPos()
  { 
    return y; 
  }
  
  boolean getEaten()
  {
    return isEaten; 
  }
  void display()
  {
    /* for(int i = 0; i < 10; i++)
     { 
    float x = random(100, 500);
    float y = random(100, 500); */ 
    imageMode(CENTER); 
    image(treats, x, y);
    if (p.getXPos() == t.getXPos() && p.getYPos() == t.getYPos())
  {
    tint(#ffffff, 0.0); 
    
  }
    
  }
}