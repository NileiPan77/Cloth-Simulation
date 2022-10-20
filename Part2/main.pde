particleSystem system;
void setup(){
    size(1024,720);
    system = new particleSystem(0,0);
    noStroke();
}

boolean running = false;
void draw(){
    background(255,255,255);
    for(int i = 0; i < 10;i++){
       system.simulateSPH(1/frameRate);
    }
    if(running) system.runningWater(1/frameRate);
    system.drawSystem();
}

void mousePressed(){
   Vec2 mousePos = new Vec2(mouseX,mouseY);
   for(int i = 0; i < system.numParticles; i++){
      float dist = mousePos.distanceTo(system.particles[i].pos);
      //println("dist:", dist);
      if(dist < system.grab_radius){
          system.particles[i].grabbed = true;
      }
   }
}

void mouseReleased(){
   for(int i = 0; i < system.numParticles; i++){
      system.particles[i].grabbed = false;
   } 
}

void keyPressed(){
    if(key == 'r'){
        running = !running;
    }
}
