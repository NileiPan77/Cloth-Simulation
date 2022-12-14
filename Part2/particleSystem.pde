public class Pair{
    particle p1,p2;
    float q,q2,q3;

    public Pair(particle p1, particle p2, float q){
        this.p1 = p1;
        this.p2 = p2;
        this.q = q;
        this.q2 = q * q;
        this.q3 = this.q2 * q;
    }
}

public class Pair3D{
    particle3D p1,p2;
    float q,q2,q3;

    public Pair3D(particle3D p1, particle3D p2, float q){
        this.p1 = p1;
        this.p2 = p2;
        this.q = q;
        this.q2 = q * q;
        this.q3 = this.q2 * q;
    }
}
class hitInfo{
  public boolean hit = false;
  public float t = 9999999;
}
public class circle{
   Vec2 center;
   Vec2 vel;
   float radius;
   
   
   public circle(float x, float y, float r1){
      this.center = new Vec2(x,y);
      this.radius = r1;
   }
   
   public hitInfo rayCircleIntersect(Vec2 l_start, Vec2 l_dir, float max_t, float eps){
        hitInfo hit = new hitInfo();
        float r = radius + eps;

        //Step 2: Compute W - a displacement vector pointing from the start of the line segment to the center of the circle
        Vec2 toCircle = this.center.minus(l_start);
        
        //Step 3: Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
        float a = 1;  //Length of l_dir (we normalized it)
        float b = -2*dot(l_dir,toCircle); //-2*dot(l_dir,toCircle)
        float c = toCircle.lengthSqr() - (r + 2)*(r + 2); //different of squared distances
        
        float d = b*b - 4*a*c; //discriminant 
        
        if (d >=0 ){ 
            //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
            //  ... this means t will be between 0 and the length of the line segment
            float t1 = (-b - sqrt(d))/(2*a); //Optimization: we only need the first collision
            float t2 = (-b + sqrt(d))/(2*a); //Optimization: we only need the first collision
            //println(hit.t,t1,t2);
            if (t1 > 0 && t1 < max_t){
                hit.hit = true;
                hit.t = t1;
            }
            else if (t1 < 0 && t2 > 0){
                hit.hit = true;
                hit.t = -1;
            }
        
        }
        
        return hit;
    }
}
public class particleSystem{

    float height;
    float width;

    float k_smooth_radius;
    float k_restDens;
    float k_stiff;
    float k_stiffN;
  
    int maxParticles;
    int numParticles;
    particle[] particles;
    particle3D[] particles3D;
    
    int numBalls;
    particle[] ballPos;
    
    int rows;
    int cols;
    
    float grab_radius;
    
    float waterRate = 0.01;
    float counter = 0;
    public particleSystem(int row, int col){
        
        this.width = 1024;
        this.height = 720;
        this.rows = row;
        this.cols = col;
        this.maxParticles = 10000;
        this.numParticles = row*col;
        this.particles = new particle[maxParticles];
        this.particles3D = new particle3D[maxParticles];
        
        this.numBalls = 0;
        ballPos = new particle[maxParticles];
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                particles[i*cols + j] = new particle(interpolate(0,cols,10,width-10,j)+random(0,10), interpolate(0,rows,10,height/2,i));
                //println("particle ",i*cols + j,":", particles[i*cols + j].pos);
                particles3D[i*cols + j] = new particle3D(interpolate(0,cols,-25,25,j),interpolate(0,cols,-25,25,i),random(-25,25));
          }
        }
        this.k_smooth_radius = 8;
        this.k_stiff = 3000;
        this.k_stiffN = 1000;
        this.k_restDens = 0.4;
        this.grab_radius = 35;
    }
    
    public void runningWater(float dt){
        counter += dt;
        if(counter > waterRate && this.numParticles < this.maxParticles){
             counter = 0;
             this.particles3D[this.numParticles] = new particle3D(-30,40,0);
             this.particles3D[this.numParticles].pos.add(new Vec3(0.3,0,0));
             this.numParticles++;
             
             this.particles3D[this.numParticles] = new particle3D(30,40,0);
             this.particles3D[this.numParticles].pos.add(new Vec3(-0.3,0,0));
             this.numParticles++;
        }
    }
    public void simulateSPH3D(float dt){
          for(int i = 0; i < numParticles; i++){
              particle3D p = particles3D[i];
              p.vel = (p.oldPos.minus(p.pos));
            
              p.vel.mul(-1.0/dt);
              p.vel.add(new Vec3(0,5*dt,0));
              //println("p.x:",p.pos.x,"p.y:",p.pos.y,"p.z:",p.pos.z);
              if(p.pos.y < -50+p.r){
                  p.pos.y = -50+p.r;
                  p.vel.y *= -0.1;
              }
              if(p.pos.y > 50-p.r){
                  p.pos.y = 50-p.r;
                  p.vel.y *= -0.1;
              }
      
              if(p.pos.x > 50-p.r){
                  p.pos.x = 50-p.r;
                  p.vel.x *= -0.1;
              }
      
              if(p.pos.x < -50 + p.r){
                  p.pos.x = -50 + p.r;
                  p.vel.x *= -0.1;
              }
              if(p.pos.z < -50 + p.r){
                  p.pos.z = -50 + p.r;
                  p.vel.z *= -0.1;
              }
              if(p.pos.z > 50 - p.r){
                  p.pos.z = 50 - p.r;
                  p.vel.z *= -0.1;
              }
              p.oldPos = new Vec3(p.pos.x,p.pos.y,p.pos.z);
              p.pos.add(p.vel.times(dt));
              p.dens = 0.0;
              p.densN = 0.0;
        }
        
        ArrayList<Pair3D> pairs = new ArrayList<Pair3D>();
        for(int i = 0; i < numParticles; i++){
            for(int j = i+1; j < numParticles; j++){
                float dist = particles[i].pos.distanceTo(particles[j].pos);
                if(dist < k_smooth_radius){
                    
                    float q = 1 - (dist/this.k_smooth_radius);
                    pairs.add(new Pair3D(particles3D[i],particles3D[j],q));
                }
            }
        }
        
        for(Pair3D p : pairs){
            p.p1.dens += p.q2;
            p.p2.dens += p.q2;
            p.p1.densN += p.q3;
            p.p2.densN += p.q3;
        }
        
        for(int i = 0; i < numParticles; i++){
            particle3D p = particles3D[i];
            p.press = this.k_stiff * (p.dens - this.k_restDens);
            p.pressN = this.k_stiffN * (p.densN);
            if(p.press > 30){
                p.press = 30;
            }
            if(p.pressN > 300){
                p.pressN = 300;
            }
            
        }
        
        for(Pair3D pair : pairs){
                particle3D a = pair.p1;
                particle3D b = pair.p2;
                float totalP = (a.press + b.press) * pair.q + (a.pressN + b.pressN) * pair.q2;
                float displace = totalP * (dt*dt);
                a.pos.add((a.pos.minus(b.pos)).normalized().times(displace));
                b.pos.add((b.pos.minus(a.pos)).normalized().times(displace));
        }
    }
    public void simulateSPH(float dt){
        for(int i = 0; i < numParticles; i++){
            particle p = particles[i];
            
            p.vel = (p.oldPos.minus(p.pos));
            
            p.vel.mul(-1.0/dt);
            p.vel.add(new Vec2(0,5*dt));
            
            if(p.pos.y < p.r){
                p.pos.y = p.r;
                p.vel.y *= -0.1;
            }
            if(p.pos.y > this.height-p.r){
                p.pos.y = this.height-p.r;
                p.vel.y *= -0.1;
            }
    
            if(p.pos.x > this.width-p.r){
                p.pos.x = this.width-p.r;
                p.vel.x *= -0.1;
            }
    
            if(p.pos.x < p.r){
                p.pos.x = p.r;
                p.vel.x *= -0.1;
            }
            
            Vec2 mousePos = new Vec2(mouseX,mouseY);
            if(p.grabbed){
                p.vel.add(mousePos.minus(p.pos).times(1/grab_radius).minus(p.vel).times(10*dt));
            }
            p.oldPos = new Vec2(p.pos.x,p.pos.y);
            p.pos.add(p.vel.times(dt));
            p.dens = 0.0;
            p.densN = 0.0;
        }
        
        

        ArrayList<Pair> pairs = new ArrayList<Pair>();
        for(int i = 0; i < numParticles; i++){
            for(int j = i+1; j < numParticles; j++){
                float dist = particles[i].pos.distanceTo(particles[j].pos);
                if(dist < k_smooth_radius){
                    float q = 1 - (dist/this.k_smooth_radius);
                    pairs.add(new Pair(particles[i],particles[j],q));
                }
            }
        }

        for(Pair p : pairs){
            p.p1.dens += p.q2;
            p.p2.dens += p.q2;
            p.p1.densN += p.q3;
            p.p2.densN += p.q3;
        }

        for(int i = 0; i < numParticles; i++){
            particle p = particles[i];
            p.press = this.k_stiff * (p.dens - this.k_restDens);
            p.pressN = this.k_stiffN * (p.densN);
            if(p.press > 30){
                p.press = 30;
            }
            if(p.pressN > 300){
                p.pressN = 300;
            }
            
            if(p.nonWater){
               p.press = 1000;
               p.pressN = 1000;
            }
            
            
        }
        for(Pair pair : pairs){
                particle a = pair.p1;
                particle b = pair.p2;
                float totalP = (a.press + b.press) * pair.q + (a.pressN + b.pressN) * pair.q2;
                float displace = totalP * (dt*dt);
                a.pos.add((a.pos.minus(b.pos)).normalized().times(displace));
                b.pos.add((b.pos.minus(a.pos)).normalized().times(displace));
        }
    }

    public void drawSystem(){
        //Vec2 mousePos = new Vec2(mouseX,mouseY);
        noStroke();
        for(int i = 0; i < numParticles; i++){
            particle3D p = particles3D[i];
            fill(p.colored.x,p.colored.y,p.colored.z,p.alpha);
            pushMatrix();
            translate(p.pos.x,p.pos.y,p.pos.z);
            sphereDetail(6);
            sphere(2 * p.r);
            popMatrix();
        }
        

    }

}
