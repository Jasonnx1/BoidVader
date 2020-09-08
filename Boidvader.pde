int previousTime;
int deltaTime;
int currentTime;

Player player;

boolean target = false;
PVector pos;

int nEnnemies = 10;
ArrayList<Boid> ennemies;

float shakeTimer = 0.0;
float shakeAmount = 0.0;

 float iniWidth = 1080; 
float iniHeight = 720;

void setup()
{
  
  size(1080, 720, P2D);
  currentTime = millis();
  previousTime = millis();
  player = new Player(width/2, height/2);
  player.score = 0;


  ennemies = new ArrayList<Boid>();
  
  for(int i = 0; i < nEnnemies; i++)
  {
    ennemies.add(new Boid());
  }
  
  
  player.fillColor = color(#3D00F7);
  
  surface.setResizable(true);


}


void draw()
{
  currentTime = millis();
  deltaTime = currentTime - previousTime;
 
  update(deltaTime);
  display(deltaTime);
  
  previousTime = currentTime;
  

}



void update(int deltatime)
{
  
  
  
  player.update(deltatime);
  
  for(Boid b : ennemies)
  {
   b.flock(ennemies); 
  }
  
  for(Boid b : ennemies)
  {
   b.update(deltatime); 
  }
  
  player.checkCollision(ennemies);
  
      
  
  
  
  
}

void display(float deltatime)
{
  
 


  background(0);
  scale(width/iniWidth, height/iniHeight);
  
  textSize(20);
  fill(255);
  text("Health: " + player.health,10,20);
  
  
  player.display(deltatime);
  
  
  for(Boid b : ennemies)
  {
     b.display(); 
  }
  
  if(shakeTimer > 0)
  {
    
    
    

     shakeAmount = random(-10,10); 
    
    
    PImage screenImage = get();
    imageMode(CORNER);
    image(screenImage, shakeAmount, shakeAmount);
    
    shakeTimer -= 1/30.0;
    
  }
 
  


  
}

void keyPressed()
{
 switch(key)
 {
  case 'r': setup();
  break;
  
  default: player.keyPressed(key);
  break;
 }
 
}

void keyReleased(){
 
  player.keyReleased(key);
  
}
