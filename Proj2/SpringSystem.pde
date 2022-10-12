public class SpringSystemRope{
    float restLen;
    float mass;
    float k;
    float kv;
    float kvf;
    ArrayList<Spring> springs;
    Spring[][] cloth;
    float ballR;
    int row;
    int col;
    Vec2 top = new Vec2(100,50);
    
    public SpringSystemRope(){
        this.restLen = 40;
        this.mass = 10;
        this.k = 20;
        this.kv = 20;
        this.kvf = 0.006;
        this.springs = new ArrayList<Spring>();
        this.row = 8;
        this.col = 8;
        this.ballR = 5;
        cloth = new Spring[this.row][this.col];
    }
    public void update(float dt){
      // 3d update
        for(int i = 0; i < this.col; i++){
           for(int j = 0; j < this.row-1; j++){
               Spring cur = this.cloth[j][i];
               Spring next = this.cloth[j+1][i];
               Vec3 d = next.pos3d.minus(cur.pos3d);
               float l = d.length();
               d.normalize();
               float v1 = dot(d,cur.vel3d);
               float v2 = dot(d,next.vel3d);
               float force = -k * (restLen-l) - kv * (v1 - v2);
               Vec3 vel = d.times(force * dt/mass);
               cur.newVel3d.add(vel);
               cur.newVel3d.subtract(cur.vel3d.times(kvf));
               next.newVel3d.subtract(vel);
           }
        }
        for(int i = 0; i < this.row; i++){
           for(int j = 0; j < this.col-1; j++){
               Spring cur = this.cloth[i][j];
               Spring next = this.cloth[i][j+1];
               Vec3 d = next.pos3d.minus(cur.pos3d);
               float l = d.length();
               d.normalize();
               float v1 = dot(d,cur.vel3d);
               float v2 = dot(d,next.vel3d);
               float force = -k * (restLen-l) - kv * (v1 - v2);
               Vec3 vel = d.times(force * dt/mass);
               cur.newVel3d.add(vel);
               cur.newVel3d.subtract(cur.vel3d.times(kvf));
               next.newVel3d.subtract(vel);
           }
        }
        

        // collision 3d
        for(int i = 1; i < this.row; i++){
           for(int j = 0; j < this.col; j++){
               //if(i == 0 && (j == 0 || j == this.col-1)) continue;
               cloth[i][j].update(dt);
               float d = ball.distanceTo(cloth[i][j].pos3d);
               if(d < r+this.ballR){
                  Vec3 n = cloth[i][j].pos3d.minus(ball);
                  n.normalize();
                  Vec3 bounce = n.times(dot(cloth[i][j].vel3d,n));
                  cloth[i][j].vel3d.subtract(bounce.times(1.1));
                  cloth[i][j].pos3d.add(n.times(0.1+r+this.ballR-d));
               }
            }
         }
    }

    public void drawSystem(){
        fill(0,0,0);
        // draw 3d
        for(int i = 0; i < this.col; i++){
           for(int j = 0; j < this.row-1; j++){
               Spring cur = this.cloth[j][i];
               Spring next = this.cloth[j+1][i];
               pushMatrix();
               line(cur.pos3d.x,cur.pos3d.y,cur.pos3d.z,next.pos3d.x,next.pos3d.y,next.pos3d.z);
               translate(next.pos3d.x,next.pos3d.y,next.pos3d.z);
               sphereDetail(6);
               sphere(this.ballR);
               popMatrix();
           }
        }
        for(int i = 0; i < this.row; i++){
           for(int j = 0; j < this.col-1; j++){
               Spring cur = this.cloth[i][j];
               Spring next = this.cloth[i][j+1];
               pushMatrix();
               line(cur.pos3d.x,cur.pos3d.y,cur.pos3d.z,next.pos3d.x,next.pos3d.y,next.pos3d.z);
               popMatrix();
           }
        }
    }

}
