Spring[][] cloth = new Spring[rows][cols];
Vec3 air = new Vec3(0,0,1);
float coeff = 0.8;
float p = 0.1;
public void joinPos(float dt){
    for(int i = 0; i < cols; i++){
         for(int j = 0; j < rows - 1; j++){
             Spring cur = cloth[j][i];
             Spring next = cloth[j+1][i];
             Vec3 d = next.pos3d.minus(cur.pos3d);
             float l = d.length();
             d.normalize();
             float v1 = dot(d,cur.vel3d);
             float v2 = dot(d,next.vel3d);
           float force = -system.k * (system.restLen-l) - system.kv * (v1 - v2);
             Vec3 vel = d.times(force * dt/system.mass);
             cur.newVel3d.add(vel);
             cur.newVel3d.subtract(cur.vel3d.times(system.kvf));
             next.newVel3d.subtract(vel);
         }
     }
   //air drag
   for(int i = 0; i < rows-1; i++){
         for(int j = 0; j < cols - 1; j++){
              Spring topLeft = cloth[i][j];
              Spring topRight = cloth[i][j+1];
              Spring bottomLeft = cloth[i+1][j];
              Spring bottomRight = cloth[i+1][j+1];
              
              Vec3 v = topLeft.vel3d.plus(topRight.vel3d.plus(bottomLeft.vel3d.plus(bottomRight.vel3d))).times(0.25).minus(air);
              Vec3 n = cross(topRight.pos3d.minus(topLeft.pos3d),bottomLeft.pos3d.minus(topLeft.pos3d)).normalized();
              float a = 0.5 * dot(v,n)/v.length();
              Vec3 v2an = n.times(v.lengthSqr() * a);
              
              Vec3 airF = v2an.times(-0.5 * p * coeff * 0.25 * dt);
              topLeft.newVel3d.add(airF);
         }
     }
   // collision 3d
    for(int i = 1; i < rows; i++){
       for(int j = 0; j < cols; j++){
           //if(i == 0 && (j == 0 || j == this.col-1)) continue;
           cloth[i][j].update(0.1);
           float d = ball.distanceTo(cloth[i][j].pos3d);
           if(d < r+system.ballR){
              Vec3 n = cloth[i][j].pos3d.minus(ball);
              n.normalize();
              Vec3 bounce = n.times(dot(cloth[i][j].vel3d,n));
              cloth[i][j].vel3d.subtract(bounce.times(1.1));
              cloth[i][j].pos3d.add(n.times(0.1+r+system.ballR-d));
           }
        }
     } 
}
public class SpringSystemRope implements Runnable{
    float restLen;
    float mass;
    float k;
    float kv;
    float kvf;
    
    float ballR;
    int row;
    int col;
    int start;
    
    int threadID;
    public SpringSystemRope(int threadId, int row, int start){
        this.restLen = 10;
        this.mass = 10;
        this.k = 50;
        this.kv = 30;
        this.kvf = 0.006;
        this.row = row;
        this.start = start;
        this.col = cols;
        this.ballR = 1;
        this.threadID = threadId;
    }
    @Override
    public void run(){
        //println("id:",this.threadID);
        try{
           this.update(0.1);
        }catch(InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void update(float dt) throws InterruptedException{
      // 3d update
      //println("row start from:",this.start);
      //println("rows:",this.row);
      //println("cols:",cols);
        for(int i = 0; i < cols; i++){
           for(int j = this.start; j < this.row - 1; j++){
               Spring cur = cloth[j][i];
               Spring next = cloth[j+1][i];
               Vec3 d = next.pos3d.minus(cur.pos3d);
               float l = d.length();
               d.normalize();
               float v1 = dot(d,cur.vel3d);
               float v2 = dot(d,next.vel3d);
               float force = -k * (restLen-l) - kv * (v1 - v2);
               Vec3 vel = d.times(force * dt/mass);
               cur.newVel3d.add(vel);
               next.newVel3d.subtract(vel);
           }
        }
        for(int i = this.start; i < this.row; i++){
           for(int j = 0; j < cols-1; j++){
               //println("i:",i,", ","j:",j);
               Spring cur = cloth[i][j];
               Spring next = cloth[i][j+1];
               Vec3 d = next.pos3d.minus(cur.pos3d);
               float l = d.length();
               d.normalize();
               float v1 = dot(d,cur.vel3d);
               float v2 = dot(d,next.vel3d);
               float force = -k * (restLen-l) - kv * (v1 - v2);
               Vec3 vel = d.times(force * dt/mass);
               cur.newVel3d.add(vel);
               next.newVel3d.subtract(vel);
           }
        }
        
        
        

        
    }

    

}

public void drawSystem(){
      for(int i = 0; i < rows-1; i++){
          for(int j = 0; j < cols-1; j++){
              Spring topLeft = cloth[i][j];
              Spring topRight = cloth[i][j+1];
              Spring bottomLeft = cloth[i+1][j];
              Spring bottomRight = cloth[i+1][j+1];
              textureMode(NORMAL); 
              beginShape();
              texture(img);
              // vertex( x, y, z, u, v) where u and v are the texture coordinates in pixels
              vertex(topLeft.pos3d.x, topLeft.pos3d.y, topLeft.pos3d.z, interpolate(0,rows,0,1,i), interpolate(0,cols,0,1,j));
              vertex(topRight.pos3d.x, topRight.pos3d.y, topRight.pos3d.z, interpolate(0,rows,0,1,i), interpolate(0,cols,0,1,j+1));
              vertex(bottomRight.pos3d.x, bottomRight.pos3d.y, bottomRight.pos3d.z, interpolate(0,rows,0,1,i+1), interpolate(0,cols,0,1,j+1));
              vertex(bottomLeft.pos3d.x, bottomLeft.pos3d.y, bottomLeft.pos3d.z, interpolate(0,rows,0,1,i+1), interpolate(0,cols,0,1,j));
              endShape();
          }
        
      }
}
