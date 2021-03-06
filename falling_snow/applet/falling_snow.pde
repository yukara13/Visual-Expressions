ArrayList particles;
PGraphics pg;

int mr[][], mg[][], mb[][];

float simplify = 2;
int far_threshold = 500;

float probability = 0.08;

boolean stop = false;

void setup() {
  size(600, 600);
  
  pg = createGraphics((int)(width/simplify), (int)(height/simplify), P2D);
  mr = new int[(int)(width/simplify)][(int)(height/simplify)];
  mg = new int[(int)(width/simplify)][(int)(height/simplify)];
  mb = new int[(int)(width/simplify)][(int)(height/simplify)];
  particles = new ArrayList();
}

void draw() {
  if(random(0,1) < probability && particles.size() < 10) {
    PVector newpos = new PVector(random(0, height/simplify), -10);
    float theta = random(PI/6*2, PI/6*4);
    float r = random(0.0, 5.0);
    PVector vel = new PVector(r*cos(theta), r*sin(theta));
    particles.add(new Particle(newpos, vel, int(random(120, 150))));
    println(particles.size());
  }
    
  // draw metaballs
  for(int i=0; i<particles.size(); i++) {
    Particle p = (Particle)this.particles.get(i);
    int px = (int)p.pos.x;
    int py = (int)p.pos.y;
    for(int y=(py-50 >= 0) ? py-50 : 0; y<py+50 && y<pg.height; y++) {
      for(int x=(px-50 >= 0) ? px-50 : 0; x<px+50 && x<pg.width; x++) {
        p.drawMetaball(x, y);
      }
    }
  }
  pg.beginDraw();
  pg.loadPixels();
  for(int y=0; y<pg.height; y++) {
    for(int x=0; x<pg.width; x++) {
      pg.pixels[x+y*pg.width] = color(mr[x][y], mg[x][y], mb[x][y], 191);
      mr[x][y] /= 1.05;
      mg[x][y] /= 1.05;
      mb[x][y] /= 1.05;
    }
  }
  pg.updatePixels();
  pg.endDraw();
  
  image(pg, 0, 0, width, height);
  
  // proc
  for(int i=0; i<particles.size(); i++) {
    Particle p = (Particle)this.particles.get(i);
    p.proc();
    if(p.dead()) {
      this.particles.remove(i);
      i--;
    }
  }
}

class Particle {
  public PVector pos;
  PVector vel;
  PVector acc;
  int t;
  int life;
  float r_ratio = 1, g_ratio = 1, b_ratio = 1;
  float ratio = 1;
  
  public Particle(PVector initPos, PVector initVel, int life) {
    this.pos = initPos;
    this.vel = initVel;
    this.life = life;
    
    this.acc = new PVector(0, 0.04);
    
    this.r_ratio = random(0.5, 1);
    this.g_ratio = random(0.5, 1);
    this.b_ratio = random(0.5, 1);
    this.ratio = random(0.2, 0.8);
  }
  
  public void drawMetaball(int x, int y) {
    float p = 10000/((x-pos.x)*(x-pos.x) + (y-pos.y)*(y-pos.y) + 1);
    mr[x][y] += p * r_ratio * ratio;
    mg[x][y] += p * g_ratio * ratio;
    mb[x][y] += p * b_ratio * ratio;
  }
  
  public void proc() {
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    
    t++;
  }
  
  public boolean dead() {
    if(pos.y > height/simplify) {
      return true;
    } else {
      return false;
    }
  }
  
}
