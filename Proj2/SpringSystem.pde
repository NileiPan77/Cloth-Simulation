public class SpringSystemRope{
    float restLen;
    float mass;
    float k;
    float kv;
    float kvf;
    ArrayList<Spring> springs;
    Spring[][] cloth;
    int row;
    int col;
    Vec2 top = new Vec2(100,50);
    
    public SpringSystemRope(){
        this.restLen = 40;
        this.mass = 30;
        this.k = 20;
        this.kv = 20;
        this.kvf = 0.006;
        this.springs = new ArrayList<Spring>();
        this.row = 4;
        this.col = 4;
        cloth = new Spring[this.row][this.col];
    }
    public void update(float dt){
      // 3d update
        //for(int i = 0; i < this.col; i++){
        //   for(int j = 0; j < this.row-1; j++){
        //       Spring cur = this.cloth[j][i];
        //       Spring next = this.cloth[j+1][i];
        //       PVector d = PVector.sub(next.pos3d,cur.pos3d);
        //       float l = d.mag();
        //       d.normalize();
        //       float v1 = d.dot(cur.vel3d);
        //       float v2 = d.dot(next.vel3d);
        //       float force = -k * (restLen-l) - kv * (v1 - v2);
        //       PVector vel = d.mult(force * dt/mass);
        //       cur.newVel3d.add(vel);
        //       PVector.mult(cur.vel3d,kvf).sub(cur.newVel3d);
        //       vel.sub(next.newVel3d);
        //   }
        //}
        //for(int i = 0; i < this.row; i++){
        //   for(int j = 0; j < this.col-1; j++){
        //       Spring cur = this.cloth[i][j];
        //       Spring next = this.cloth[i][j+1];
        //       PVector d = PVector.sub(next.pos3d,cur.pos3d);
        //       float l = d.mag();
        //       d.normalize();
        //       float v1 = d.dot(cur.vel3d);
        //       float v2 = d.dot(next.vel3d);
        //       float force = -k * (restLen-l) - kv * (v1 - v2);
        //       PVector vel = d.mult(force * dt/mass);
        //       cur.newVel3d.add(vel);
        //       PVector.mult(cur.vel3d,kvf).sub(cur.newVel3d);
        //       vel.sub(next.newVel3d);
        //   }
        //}
        
        // 2d update
        for(int i = 0; i < this.col; i++){
           for(int j = 0; j < this.row-1; j++){
               Spring cur = this.cloth[j][i];
               Spring next = this.cloth[j+1][i];
               Vec2 d = next.pos.minus(cur.pos);
               float l = d.length();
               d.normalize();
               float v1 = dot(d,cur.vel);
               float v2 = dot(d,next.vel);
               float force = -k * (restLen-l) - kv * (v1 - v2);
               Vec2 vel = d.times(force * dt/mass);
               cur.newVel.add(vel);
               cur.newVel.subtract(cur.vel.times(kvf));
               next.newVel.subtract(vel);
           }
        }
        for(int i = 0; i < this.row; i++){
           for(int j = 0; j < this.col-1; j++){
               Spring cur = this.cloth[i][j];
               Spring next = this.cloth[i][j+1];
               Vec2 d = next.pos.minus(cur.pos);
               float l = d.length();
               d.normalize();
               float v1 = dot(d,cur.vel);
               float v2 = dot(d,next.vel);
               float force = -k * (restLen-l) - kv * (v1 - v2);
               Vec2 vel = d.times(force * dt/mass);
               cur.newVel.add(vel);
               cur.newVel.subtract(cur.vel.times(kvf));
               next.newVel.subtract(vel);
           }
        }
        
        //Collision Detection 2d
        for(int i = 0; i < this.row; i++){
           for(int j = 0; j < this.col; j++){
               if(i == 0 && (j == 0 || j == this.col-1)) continue;
               cloth[i][j].update(dt);
               float d = sphere.distanceTo(cloth[i][j].pos);
               if(d < r+0.09){
                  Vec2 n = cloth[i][j].pos.minus(sphere);
                  n.normalize();
                  Vec2 bounce = n.times(dot(cloth[i][j].vel,n));
                  cloth[i][j].vel.subtract(bounce.times(1.1));
                  cloth[i][j].pos.add(n.times(0.1+r-d));
               }
           }
        }

        // collision 3d
        //for(int i = 0; i < this.row; i++){
        //   for(int j = 0; j < this.col; j++){
        //       if(i == 0 && (j == 0 || j == this.col-1)) continue;
        //       //cloth[i][j].update(dt);
        //       float d = PVector.sub(ball, cloth[i][j].pos3d).mag();
        //       //float d = sphere.distanceTo(cloth[i][j].pos);
        //       if(d < r+0.09){
        //          PVector normal = PVector.sub(cloth[i][j].pos3d,ball);
        //          //Vec2 n = cloth[i][j].pos.minus(sphere);
        //          normal.normalize();
        //          PVector bounce = normal.mult(normal.dot(cloth[i][j].vel3d));
        //          bounce.mult(1.1).sub(cloth[i][j].vel3d);
        //          //cloth[i][j].vel.subtract(bounce.mult(1.1));
        //          cloth[i][j].pos3d.add(normal.mult(0.1+r-d));
        //          //cloth[i][j].pos.add(n.times(0.1+r-d));
        //       }
        //   }
        //}
    }

    public void drawSystem(){
        fill(0,0,0);
        // draw 2d
        for(int i = 0; i < this.col; i++){
           for(int j = 0; j < this.row-1; j++){
               Spring cur = this.cloth[j][i];
               Spring next = this.cloth[j+1][i];
               pushMatrix();
               line(cur.pos.x,cur.pos.y,next.pos.x,next.pos.y);
               translate(next.pos.x,next.pos.y);
               sphere(10);
               popMatrix();
           }
        }
        for(int i = 0; i < this.row; i++){
           for(int j = 0; j < this.col-1; j++){
               Spring cur = this.cloth[i][j];
               Spring next = this.cloth[i][j+1];
               pushMatrix();
               line(cur.pos.x,cur.pos.y,next.pos.x,next.pos.y);
               popMatrix();
           }
        }
        // draw 3d
        //for(int i = 0; i < this.col; i++){
        //   for(int j = 0; j < this.row-1; j++){
        //       Spring cur = this.cloth[j][i];
        //       Spring next = this.cloth[j+1][i];
        //       pushMatrix();
        //       line(cur.pos3d.x,cur.pos3d.y,cur.pos3d.z,next.pos3d.x,next.pos3d.y,next.pos3d.z);
        //       translate(next.pos3d.x,next.pos3d.y,next.pos3d.z);
        //       sphere(10);
        //       popMatrix();
        //   }
        //}
        //for(int i = 0; i < this.row; i++){
        //   for(int j = 0; j < this.col-1; j++){
        //       Spring cur = this.cloth[i][j];
        //       Spring next = this.cloth[i][j+1];
        //       pushMatrix();
        //       line(cur.pos3d.x,cur.pos3d.y,cur.pos3d.z,next.pos3d.x,next.pos3d.y,next.pos3d.z);
        //       popMatrix();
        //   }
        //}
    }

}
