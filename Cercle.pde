class Cercle
{
  
  PVector location;
  int rayon;
  
  
  
  
  Cercle(int tempRayon, float x, float y)
  {
    location = new PVector(x, y);
    rayon = tempRayon;
  }
  
  
  void display()
  {
    noStroke();
    fill(255,0,0, 100);
    ellipse(location.x, location.y, rayon*2, rayon*2);
    
  }
  
  void Pdisplay(color Pcolor)
  {
    fill(Pcolor);
    ellipse(location.x, location.y, rayon*2, rayon*2);
    
  }
  
  
  
}
