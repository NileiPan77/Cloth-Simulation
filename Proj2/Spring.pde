public class Spring{
    PVector pos3d;
    PVector vel3d;
    PVector newVel3d;
    Vec2 pos;

    Vec2 vel;
    Vec2 newVel;

    public Spring(){
        this.pos = new Vec2(100,100);
        this.vel = new Vec2(0,0);
        this.newVel = new Vec2(0,0);
        
        this.pos3d = new PVector(100,100,0);
        this.vel3d = new PVector(0,0,0);
        this.newVel3d = new PVector(0,0,0);
    }

    public Spring(PVector pos){
        this.pos = new Vec2(pos.x,pos.y);
        this.vel = new Vec2(0,0);
        this.newVel = new Vec2(0,0);
        
        this.pos3d = pos;
        this.vel3d = new PVector(0,0,0);
        this.newVel3d = new PVector(0,0,0);
    }

    public void update(float dt){
        this.newVel3d.add(new PVector(0,10*dt,0));
        this.vel3d = this.newVel3d;
        this.pos3d.add(PVector.mult(this.vel3d,dt));
        
        this.newVel.add(new Vec2(0,10*dt));
        this.vel = this.newVel;
        this.pos.add(this.vel.times(dt));
        
    }


}
