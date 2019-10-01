class Player extends GraphicObject
{
  
  float topSpeed = 5;
  float power = 0.3;
  float topSteer = 0.1;
  
  float mass = 1;
  
  float theta = 0;
  float r = 10; // Rayon du boid
  
  float cooldown;
  
  ArrayList<Laser> lasers;
  
  boolean gameOver = false;
  boolean win = false;
  
  int shootingPower = 10;
  
  Cercle box;
  
  Player(float x, float y)
  {    
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    box = new Cercle(14, location.x, location.y);
    cooldown = 0;
    lasers = new ArrayList<Laser>();
  }
  
  ArrayList<Laser> getLasers()
  {
   return lasers; 
  }
 
   void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);    
  }
  
  void update(float deltaTime)
  {
    
    for(int i = 0; i < lasers.size(); i++)
    {
      if( lasers.get(i).checkOut() )
      {
        lasers.remove(i);
      }
    }
    
    cooldown += deltaTime;

    
    if (location.x < 0) {
      location.x = width - r;
    } else if (location.x + r> width) {
      location.x = 0;
    }
    
    if (location.y < 0) {
      location.y = height - r;
    } else if (location.y + r> height) {
      location.y = 0;
    }
    
    
    if(keyPressed)
    {
     switch(key)
     {
       
      case 'w': applyForce(new PVector( (power * cos( theta - radians(90) ) ) , (power * sin( theta - radians(90) ) ) ) );
      break;
      
      case 'a': theta -= 0.07;
      break;
      
      case 'd': theta += 0.07;
      break;
      
      case ' ': if(cooldown > 100 && lasers.size() < 5) { 
                  shoot(new PVector( (shootingPower * cos( theta - radians(90) ) ) , (shootingPower * sin( theta - radians(90) ) ) ), location);
                  cooldown = 0;
                }
      break;
      
      
     }
    }
    
    for(Laser l : lasers)
    {
      l.update(deltaTime); 
    }
    
    velocity.add (acceleration);
    velocity.limit(topSpeed);
    location.add (velocity);
    acceleration.mult (0);      
    
    box.location.x = location.x;
    box.location.y = location.y;
       
  }
  
  void shoot(PVector dir, PVector loc)
  {
    
    lasers.add( new Laser(new PVector(dir.x, dir.y) , new PVector(loc.x, loc.y) ) );
    
  }
  
  void collision(Boid b)
  {
    
    if(PVector.dist(location, b.location) < box.rayon + b.box.rayon )
    {
      gameOver = true;
    }
    
  }
  
  void display()
  {
    if(win)
    {
      textSize(100);
      fill(0,255,0);
      text("You Win !", width/2 - 270, height/2);
      textSize(50);
      text("Press R to reset", width/2 - 200, height/2 + 100);
    }
    else if(gameOver)
    {
      
      textSize(100);
      fill(255,0,0);
      text("Game Over", width/2 - 270, height/2);
      textSize(50);
      text("Press R to reset", width/2 - 200, height/2 + 100);
      
    }
    else
    {
    
    for(Laser l : lasers)
    {
      l.display(); 
    }
    
    noStroke();
    fill(fillColor);
    
    pushMatrix();
    translate(location.x, location.y);
    rotate (theta);
    
    beginShape(TRIANGLES);
      vertex(0, -r * 2);
      vertex(-r, r * 2);
      vertex(r, r * 2);
    
    endShape();
    
    
    popMatrix();
    
    }
  }
  
  
}
