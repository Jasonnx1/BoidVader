class Boid extends GraphicObject {
  float topSpeed = 4;
  float topSteer = 0.05;
  
  float mass = 1;
  
  float theta = 0;
  float radius = 30; // Rayon du boid
  
  float radiusSeparation = 30 * radius;
  float radiusAlignment = 30 * radius;
  float radiusCohesion = 30 * radius;

  float weightSeparation = 2;
  float weightAlignment = 1;
  float weightCohesion = 1;
  
  boolean touched = false;

  
  PVector steer;
  PVector sumAlignment;
  PVector sumCohesion;

  PVector zeroVector = new PVector(0, 0);
  

  boolean debug = false;
  int msgCount = 0;
  String debugMessage = "";
  
  Boid () {
    location = new PVector(random(width),random(height));
    velocity = new PVector(1,1);
    acceleration = new PVector(0,0);

    
  }
  
  
  Boid (PVector loc, PVector vel) {
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);


    
  }
  
  void checkEdges() {
    
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

  void flock (ArrayList<Boid> boids) {
    PVector separation = separate(boids);
    PVector alignment = align(boids);
    PVector cohesion = cohesion(boids);
    
    separation.mult(weightSeparation);
    alignment.mult(weightAlignment);
    cohesion.mult(weightCohesion);

    applyForce(separation);
    applyForce(alignment);
    applyForce(cohesion);
  }
  
  
  void update(float deltaTime) {
    checkEdges();

    velocity.add (acceleration);
    velocity.limit(topSpeed);

    theta = velocity.heading() + radians(90);

    location.add (velocity);

    acceleration.mult (0);      

    
  }
  
  void display() {
    noStroke();
    fill(fillColor);
    
    pushMatrix();
    stroke(255,0,0);
    strokeWeight(2);
    
    translate(location.x, location.y);
    rotate (theta + PI + HALF_PI);
    
    
    line(radius/2, 0, -radius*0.4, -radius/3);
    line(-radius*0.4, -radius/3, -radius/10 ,0);
    line(-radius/10, 0, -radius*0.4, radius/3);
    line(-radius*0.4, radius/3, radius/2, 0);
    
    // fill(255,0,0,100);
    // ellipse(0,0,radius,radius);
    
    popMatrix();

    

  }
  
  PVector separate (ArrayList<Boid> boids) {
    if (steer == null) {
      steer = new PVector(0, 0, 0);
    }
    else {
      steer.setMag(0);
    }
    
    int count = 0;
    
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      
      if (d > 0 && d < radiusSeparation) {
        PVector diff = PVector.sub(location, other.location);
        
        diff.normalize();
        diff.div(d);
        
        steer.add(diff);
        
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
    }
    
    if (steer.mag() > 0) {
      steer.setMag(topSpeed);
      steer.sub(velocity);
      steer.limit(topSteer);
    }
    
    return steer;
  }

  PVector align (ArrayList<Boid> boids) {

    if (sumAlignment == null) {
      sumAlignment = new PVector();      
    } else {
      sumAlignment.mult(0);
    }

    int count = 0;

    for (Boid other : boids) {
      float d = PVector.dist(this.location, other.location);

      if (d > 0 && d < radiusAlignment) {
        sumAlignment.add(other.velocity);
        count++;
      }
    }

    if (count > 0) {
      sumAlignment.div((float)count);
      sumAlignment.setMag(topSpeed);

      PVector steer = PVector.sub(sumAlignment, this.velocity);
      steer.limit(topSteer);

      return steer;
    } else {
      return zeroVector;
    }
  }

   // Méthode qui calcule et applique une force de braquage vers une cible
  // STEER = CIBLE moins VITESSE
  PVector seek (PVector target) {
    // Vecteur différentiel vers la cible
    PVector desired = PVector.sub (target, this.location);
    
    // VITESSE MAXIMALE VERS LA CIBLE
    desired.setMag(topSpeed);
    
    // Braquage
    PVector steer = PVector.sub (desired, velocity);
    steer.limit(topSteer);
    
    return steer;    
  }

  PVector cohesion (ArrayList<Boid> boids) {
    if (sumCohesion == null) {
      sumCohesion = new PVector();      
    } else {
      sumCohesion.mult(0);
    }

    int count = 0;

    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);

      if (d > 0 && d < radiusCohesion) {
        sumCohesion.add(other.location);
        count++;
      }
    }

    if (count > 0) {
      sumCohesion.div(count);

      return seek(sumCohesion);
    } else {
      return zeroVector;
    }
    
  }
  
  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);    
  }
  
  
}
