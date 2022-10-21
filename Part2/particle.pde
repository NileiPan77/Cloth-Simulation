public class particle{
    Vec2 pos;
    Vec2 oldPos;
    Vec2 vel;
    Vec3 colored;
    float r;
    float alpha;
    float press;
    float pressN;
    float dens;
    float densN;
    boolean grabbed;
    boolean nonWater;
    public particle(float x, float y){
        this.pos = new Vec2(x,y);
        this.oldPos = new Vec2(x,y);
        this.vel = new Vec2(0,0);
        this.alpha = 100;
        this.colored = new Vec3(78,103,176);
        this.r = 10;
        this.press = 0.0;
        this.pressN = 0.0;
        this.dens = 0.0;
        this.densN = 0.0;
        this.nonWater = false;
    }
}
