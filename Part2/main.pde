particleSystem system;

PImage tap;
PImage tap_r;

PImage duck;

PImage shelf;
void setup(){
    size(1024,720);
    system = new particleSystem(0,0);
    tap = loadImage("tap.jpg");
    tap_r = loadImage("tap_r.jpg");
    duck = loadImage("duck2.png");
    shelf = loadImage("shelf.png");
}

boolean running = false;
void draw(){
    background(255,255,255);
    image(tap, 200, 20);
    image(tap_r, 600, 20);
    image(shelf,0,230,460,270);
    image(shelf,560,230,460,270);
    for(int i = 0; i < 10;i++){
       system.simulateSPH(1/frameRate);
    }
    if(running) system.runningWater(1/frameRate);
    noStroke();
    system.drawSystem();
    
    
    
}

void mousePressed(){
   Vec2 mousePos = new Vec2(mouseX,mouseY);
   if(system.numParticles < system.maxParticles){
        particle p = new particle(mouseX,mouseY);
        p.colored = new Vec3(255,125,0);
        p.alpha = 255;
        p.r = 20;
        p.nonWater = true;
        system.particles[system.numParticles] = p;
        system.numParticles++;
        
        system.ballPos[system.numBalls++] = p;
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
