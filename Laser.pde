class Laser extends GraphicObject
{
 
  boolean touch = false;

  Laser(PVector dir, PVector loc)
  {
   
    velocity = dir;
    location = loc;
  }
  
  void update(float deltaTime)
  {
    location.add(velocity);
  }
  
  boolean checkCollision(Boid b)
  {
    
    if(PVector.dist(b.location, location) < b.box.rayon || PVector.dist(b.location, new PVector(location.x+(velocity.x*5) , location.y+(velocity.y*5) ) ) < b.box.rayon )
    {
      return true;
    }
    
    return false;
  }
  
  boolean checkOut()
  {
    if(location.x < 0 || location.x > width || location.y < 0 || location.y > height )
    {
     return true; 
    }
    return false;
  }
  
  void display()
  {
    fill(255,0,0);
    stroke(255,0,0);
    strokeWeight(3);
    line(location.x, location.y, location.x+(velocity.x) , location.y+(velocity.y) );
    strokeWeight(1);
    
  }
  
}
