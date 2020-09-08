class Player extends GraphicObject
{
  
  float topSpeed = 5;
  float power = 0.3;
  float topSteer = 0.1;
  
  float theta = 0;
  float radius = 40; // Rayon du boid
  
  int score = 0;
  float hitCooldown = 0.0;
 

  int health = 100;
  
  public boolean keyForward, keyLeft, keyRight;
  
  int shootingPower = 10;
  
  
  
  Player(float x, float y)
  {    
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    keyForward = false;
    keyRight = false;
    keyLeft = false;
    


  }
  

 
   void applyForce (PVector force) {
     
    this.acceleration.add(force);
    
  }
  
  void checkEdges()
  {
    
    if (location.x + radius/2 < 0) {
      location.x = width + radius/2 ;
    } else if (location.x - radius/2> width) {
      location.x = 0 - radius/2;
    }
    
    if (location.y + radius/2 < 0) {
      location.y = height + radius/2;
    } else if (location.y - radius/2 > height) {
      location.y = 0 - radius/2;
    }
    
    
    
  }
  
  void update(float deltaTime)
  {
    
       checkEdges();

       if(hitCooldown == 0)
       {
           if(keyForward)
           {
             applyForce(new PVector( (power * cos( theta - radians(90) ) ) , (power * sin( theta - radians(90) ) ) ) );
           }
           else
           {
             if( (velocity.x > 0.001 || velocity.y > 0.001) || (velocity.x < -0.001 || velocity.y < -0.001) )
             {
               applyForce(new PVector(-velocity.x/40, -velocity.y/40) );
             }
             else
             {
               velocity.x = 0;
               velocity.y = 0;
             }
           }
           
           if(keyLeft)
           {
             theta -= 0.07;
           }
           
           if(keyRight)
           {
             theta += 0.07;
           }
           
           if(keyForward && keyRight && keyLeft)
           {
            
             score = 0;
             
           }
           else if(keyForward &&  keyRight)
           {
             
             score++;
             
           }
           else if (keyForward && keyLeft)
           {
             
             score++;
             
           }
           else 
           {
            score = 0; 
           }  
         
       }
       
       
    
      
      
  
    
    
    
    velocity.add (acceleration);
    velocity.limit(topSpeed);
    location.add (velocity);
    acceleration.mult (0);      

    
    
       
  }
  
  void checkCollision(ArrayList<Boid> boids)
  {
   
    for(Boid b : boids)
    {
      
       if(PVector.dist(b.location, location) < b.radius/2 + radius/2 )
       {
         
         if(hitCooldown == 0)
         {
           health -= 10;
           hitCooldown = 700;
           shakeTimer = 0.15;
         }
         
       }
      
    }
    
  }
  

  
  void display(float deltatime)
  {
    
    if(hitCooldown != 0)
    {
      
      hitCooldown -= deltatime;
      
      if(hitCooldown < 0)
      {
         hitCooldown = 0; 
      }
      
      if(hitCooldown < 200)
      {
        
        stroke(200);
        
      }
      else if(hitCooldown < 400)
      {
        
        stroke(100);
        
      }
      else if(hitCooldown < 600)
      {
        
        stroke(200);
        
      }
      else if(hitCooldown < 800)
      {
        
        stroke(100);
        
      }
      else
      {
       
        stroke(200);
        
      }
      
      
    }
    else
    {
      stroke(60, 247, 255);
    }

    pushMatrix();
    
    strokeWeight(2);
    
    translate(location.x, location.y);
    rotate (theta + PI + HALF_PI);
  
    line(radius/2, 0, -radius*0.4, -radius/3);
    line(-radius*0.4, -radius/3, -radius/10 ,0);
    line(-radius/10, 0, -radius*0.4, radius/3);
    line(-radius*0.4, radius/3, radius/2, 0);
    
    if(keyForward && hitCooldown == 0)
    {
      stroke(255,0,0);
      
      line(-radius/4, -radius/8, -radius/2, 0);
      line(-radius/2 ,0 , -radius/4, radius/8);
     
    }
    
  //  fill(255,0,0,100);
  //  ellipse(0,0,radius,radius);
    
    popMatrix();
    

    

      
    
  }
  
  void keyPressed(char c)
  {
    
    switch(c)
    {
      case 'w': keyForward = true;
      break;
      case 'd': keyRight = true;
      break;
      case 'a': keyLeft = true;
      
    }
  }
  
  void keyReleased(char c)
  {
    
        switch(c)
    {
      case 'w': keyForward = false;
      break;
      case 'd': keyRight = false;
      break;
      case 'a': keyLeft = false;
      
    }
  }
  
  void display(){}
    
  
  
  
}
