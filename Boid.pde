class Boid extends GraphicObject {
  float topSpeed = 4;
  float topSteer = 0.05;
  
  float mass = 1;
  
  float theta = 0;
  float r = 10; // Rayon du boid
  
  float radiusSeparation = 10 * r;
  float radiusAlignment = 20 * r;
  float radiusCohesion = 30 * r;

  float weightSeparation = 1.9;
  float weightAlignment = 2;
  float weightCohesion = 1;
  
  boolean touched = false;
  

  
  
  Cercle box;
  
  PVector steer;
  PVector sumAlignment;
  PVector sumCohesion;

  PVector zeroVector = new PVector(0, 0);
  

  boolean debug = false;
  int msgCount = 0;
  String debugMessage = "";
  
  Boid () {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    box = new Cercle(16, location.x, location.y);

    
  }
  
  Boid (PVector loc, PVector vel) {
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);
    box = new Cercle(16, location.x, location.y);

    
  }
  
  void checkEdges() {
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
    
    box.location.x = location.x;
    box.location.y = location.y;
    
  }
  
  void display() {
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
