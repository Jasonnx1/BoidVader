int previousTime;
int deltaTime;
int currentTime;
ArrayList<Boid> ennemies;
int Nennemies = 50;
Player player;
PImage bg;
boolean target = false;
PVector pos;
int score = 0;

void setup()
{
  fullScreen(P2D);
  currentTime = millis();
  previousTime = millis();
  ennemies = new ArrayList<Boid>();
  player = new Player(width/2, height/2);
  score = 0;
  
  do
  {
   pos = new PVector(random(0, width), random(0, height ) );
  }
  while( PVector.dist(pos, player.location) < height/3 );
  
  for (int i = 0; i < Nennemies; i++) {
    Boid b = new Boid(new PVector(pos.x, pos.y), new PVector(random (-2, 2), random(-2, 2)));
    b.fillColor = color(#CFE5F7);
    ennemies.add(b);
    
  }
  
  bg = loadImage("Images/space.jpg");
  bg.resize(width, height);
  
  
  player.fillColor = color(#3D00F7);
  
}


void draw()
{
  currentTime = millis();
  deltaTime = currentTime - previousTime;
 
  update(deltaTime);
  display();
  
  previousTime = currentTime;
}



void update(int deltatime)
{
  
  player.update(deltatime);
  
  for(Boid b : ennemies)
  {
      b.flock(ennemies);
      b.update(deltatime);
  }
  
  for (int i = ennemies.size() - 1; i >= 0; i--) {
 
   if(PVector.dist(player.location, ennemies.get(i).location) < 40 )
    player.collision ( ennemies.get(i) );
 
   for(int j = player.lasers.size() - 1; j >= 0; j-- )
   {
     
     if(PVector.dist(player.lasers.get(j).location, ennemies.get(i).location) < 40  )
     {
         if(player.lasers.get(j).checkCollision(ennemies.get(i)) )
          {
            
            target = true;
            player.lasers.remove(j);
                
          }
     } 
   }
   
   if(target == true)
   {
   ennemies.remove(i);
   score++;
   }
   
   if(ennemies.size() == 0)
   {
    player.win = true; 
   }
   
   target = false;

    
  }
  
  
  
}

void display()

{


  background(bg);
  
  textSize(20);
  fill(0,255,0);
  text("Score: " + score,10,20);
  
  fill(0,255,0);
  text("Ennemies: " + ennemies.size(),10,40);
  
    player.display();
  
  for(Boid b : ennemies)
  {
    
    b.display();
    
  }
  
}

void keyPressed()
{
 if(key == 'r') setup(); 
}
