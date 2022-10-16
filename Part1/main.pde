SpringSystemRope system;
int threads = 1;
int rows = 16;
int cols = 16;
int rowsPerThread = rows/threads;
Thread myThreads[] = new Thread[threads];

Vec2 sphere = new Vec2(200,300);
Vec3 ball = new Vec3(300,350,200);
PShape globe;
float r = 100;
Camera camera;

PImage img;
PImage goldy;
void setup(){
    size(1024,720,P3D);
    system = new SpringSystemRope(0, rows, 0);
    for(int i = 0; i < rows; i++){
       for(int j = 0; j < cols; j++){
          cloth[i][j] = new Spring(new Vec3(150 + 15 * j, 200 , 100 + 5 * i)); 
       }
    }
    
    for(int i = 0; i < threads; i++){
       SpringSystemRope r = new SpringSystemRope(i, i * rowsPerThread + rowsPerThread, i * rowsPerThread); 
       myThreads[i] = new Thread(r);
    }
    img = loadImage("black-fabric.jpg");
    goldy = loadImage("white-fabric.jpg");
    camera = new Camera();
    globe = createShape(SPHERE, r); 
    globe.setTexture(goldy);
    noStroke();
    hint(ENABLE_DEPTH_SORT);
}

void draw(){
    background(255,255,255);
    for(int i = 0; i < threads; i++){
       SpringSystemRope r = new SpringSystemRope(i, i * rowsPerThread + rowsPerThread, i * rowsPerThread); 
       myThreads[i] = new Thread(r);
       myThreads[i].start();
    }
    for(int i = 0; i < threads; i++){
      try{
          myThreads[i].join();
      }catch(InterruptedException e) {
            e.printStackTrace();
      }
    }
    joinPos(0.1);
    camera.update(0.1);
    directionalLight(255.0, 255.0, 255.0, -1, 1, -1);

    drawSystem();
    
    fill(200,120,120);
    translate(ball.x,ball.y,ball.z);
    shape(globe);
    
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
