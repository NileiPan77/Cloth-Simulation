public class particle3D{
    Vec3 pos;
    Vec3 oldPos;
    Vec3 vel;
    Vec3 colored;
    float r;
    float alpha;
    float press;
    float pressN;
    float dens;
    float densN;
    boolean grabbed;
    boolean nonWater;
    public particle3D(float x, float y,float z){
        this.pos = new Vec3(x,y,z);
        this.oldPos = new Vec3(x,y,z);
        this.vel = new Vec3(0,0,0);
        this.alpha = 100;
        this.colored = new Vec3(78,103,176);
        this.r = 1;
        this.press = 0.0;
        this.pressN = 0.0;
        this.dens = 0.0;
        this.densN = 0.0;
        this.nonWater = false;
    }
}
