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

public class particleSystem{
    float r;
    float height;
    float width;

    float k_smooth_radius;
    float k_restDens;
    float k_stiff;
    float k_stiffN;
  
    int maxParticles;
    int numParticles;
    particle[] particles;

    int rows;
    int cols;
    
    float grab_radius;
    
    float waterRate = 0.01;
    float counter = 0;
    public particleSystem(int row, int col){
        r = 18;
        this.width = 1024;
        this.height = 720;
        this.rows = row;
        this.cols = col;
        this.maxParticles = 10000;
        this.numParticles = row * col;
        this.particles = new particle[maxParticles];
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                particles[i*cols + j] = new particle(interpolate(0,cols,10,width-10,j)+random(0,10), interpolate(0,rows,10,height/2,i));
                //println("particle ",i*cols + j,":", particles[i*cols + j].pos);  
          }
        }
        this.k_smooth_radius = r;
        this.k_stiff = 3000;
        this.k_stiffN = 1000;
        this.k_restDens = 0.2;
        this.grab_radius = 35;
    }
    
    public void runningWater(float dt){
        counter += dt;
        if(counter > waterRate && this.numParticles < this.maxParticles){
             counter = 0;
             this.particles[this.numParticles] = new particle(100,100);
             this.particles[this.numParticles].pos.add(new Vec2(0.3,0));
             this.numParticles++;
             
             this.particles[this.numParticles] = new particle(300,100);
             this.particles[this.numParticles].pos.add(new Vec2(-0.3,0));
             this.numParticles++;
        }
    }
    public void simulateSPH(float dt){
        for(int i = 0; i < numParticles; i++){
            particle p = particles[i];
            
            p.vel = (p.oldPos.minus(p.pos));
            
            p.vel.mul(-1.0/dt);
            p.vel.add(new Vec2(0,5*dt));
            
            if(p.pos.y < r){
                p.pos.y = r;
                p.vel.y *= -0.1;
            }
            if(p.pos.y > this.height-r){
                p.pos.y = this.height-r;
                p.vel.y *= -0.1;
            }
    
            if(p.pos.x > this.width-r){
                p.pos.x = this.width-r;
                p.vel.x *= -0.1;
            }
    
            if(p.pos.x < r){
                p.pos.x = r;
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
        for(int i = 0; i < numParticles; i++){
            float q = particles[i].press/30;
            //fill((0.7-q*0.5)*255,(0.8-q*0.4)*255,(1.0-q*0.2)*255);
            fill(78,103,176);
            circle(particles[i].pos.x,particles[i].pos.y,2 * r);
            if(particles[i].grabbed){
               line(mouseX,mouseY,particles[i].pos.x,particles[i].pos.y);
            }
        }

    }

}
