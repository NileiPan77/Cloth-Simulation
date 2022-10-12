SpringSystemRope system;

Vec2 sphere = new Vec2(200,300);
Vec3 ball = new Vec3(300,350,100);
float r = 100;
Camera camera;
void setup(){
    size(1024,720,P3D);
    system = new SpringSystemRope();
    for(int i = 0; i < system.row; i++){
       for(int j = 0; j < system.col; j++){
          system.cloth[i][j] = new Spring(new Vec3(100 + 50 * j, 200 , 100 + 50 * i)); 
       }
    }
    camera = new Camera();
    camera.position = new PVector(200,300,700);
    blendMode(BLEND);
    hint(ENABLE_DEPTH_SORT);
}

void draw(){
    background(255,255,255);
    system.update(0.1);
    camera.update(0.1);
    directionalLight(255.0, 255.0, 255.0, -1, 1, -1);

    system.drawSystem();
    
    fill(200,120,120);
    translate(ball.x,ball.y,ball.z);
    sphereDetail(12);
    sphere(r);
}

float speed = 10;
void keyPressed(){
    camera.HandleKeyPressed();
   if(keyCode == UP){
      ball.add(new Vec3(0,0,-speed)); 
   }
   if(keyCode == DOWN){
      ball.add(new Vec3(0,0,speed)); 
   }
   if(keyCode == RIGHT){
      ball.add(new Vec3(speed,0,0)); 
   }
   if(keyCode == LEFT){
      ball.add(new Vec3(-speed,0,0)); 
   }
}


void mousePressed(){
  camera.mousePressed(); 
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
void mouseReleased(){
    camera.mouseReleased(); 
}

void mouseDragged(){
   camera.mouseDragged(); 
}

void mouseWheel(MouseEvent event){
  camera.mouseWheel(event);
}
