particleSystem system;

Camera cam = new Camera();
void setup(){
    size(1024,720,P3D);
    system = new particleSystem(50,50);
}

boolean running = false;
void draw(){
    background(255,255,255);
    for(int i = 0; i < 5;i++){
       system.simulateSPH3D(1/frameRate);
    }
    if(running) system.runningWater(1/frameRate);
    //
    system.drawSystem();
    
    cam.update(1/frameRate);
    noFill();
    stroke(0);
    box(100);
}

void mousePressed(){
    cam.mousePressed();
}

void mouseReleased(){
    cam.mouseReleased();
}

void mouseDragged(){
    cam.mouseDragged();
}

void mouseWheel(MouseEvent event){
    cam.mouseWheel(event); 
}
void keyPressed(){
    if(key == 'r'){
        running = !running;
    }
}
