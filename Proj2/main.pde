SpringSystemRope system;

Vec2 sphere = new Vec2(200,300);
PVector ball = new PVector(200,300,0);
float r = 50;
void setup(){
    size(400,500,P3D);
    system = new SpringSystemRope();
    for(int i = 0; i < system.row; i++){
       for(int j = 0; j < system.col; j++){
          system.cloth[i][j] = new Spring(new PVector(100 + 50 * j, 100 + 50 * i,0)); 
       }
    }
}

void draw(){
    background(255,255,255);
    system.update(0.1);

    system.drawSystem();
    
    fill(200,120,120);
    circle(sphere.x,sphere.y,2*r);
}

float speed = 10;
void keyPressed(){
   if(keyCode == UP){
      sphere.add(new Vec2(0,-speed)); 
   }
   if(keyCode == DOWN){
      sphere.add(new Vec2(0,speed)); 
   }
   if(keyCode == RIGHT){
      sphere.add(new Vec2(speed,0)); 
   }
   if(keyCode == LEFT){
      sphere.add(new Vec2(-speed,0)); 
   }
}
