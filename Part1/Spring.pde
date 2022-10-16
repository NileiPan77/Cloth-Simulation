public class Spring{
    Vec3 pos3d;
    Vec3 vel3d;
    Vec3 newVel3d;
    Vec2 pos;

    Vec2 vel;
    Vec2 newVel;

    public Spring(){
        this.pos = new Vec2(100,100);
        this.vel = new Vec2(0,0);
        this.newVel = new Vec2(0,0);
        
        this.pos3d = new Vec3(100,100,0);
        this.vel3d = new Vec3(0,0,0);
        this.newVel3d = new Vec3(0,0,0);
    }

    public Spring(Vec3 pos){
        this.pos = new Vec2(pos.x,pos.y);
        this.vel = new Vec2(0,0);
        this.newVel = new Vec2(0,0);
        
        this.pos3d = pos;
        this.vel3d = new Vec3(0,0,0);
        this.newVel3d = new Vec3(0,0,0);
    }

    public void update(float dt){
        this.newVel3d.add(new Vec3(0,10*dt,0));
        this.vel3d = this.newVel3d;
        this.pos3d.add(this.vel3d.times(dt));
        
    }


}
