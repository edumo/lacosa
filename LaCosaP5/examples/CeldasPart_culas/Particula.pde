class Particula {

  PVector pos;
  PVector end;
  PVector move;
  color c;
  int maxLife = 1024;
  int life;
  boolean aniadidas = false;

  public void init(PVector pos, PVector end, PVector move, color c) {
    this.pos = pos;
    this.move = move;
    this.end =  end;
    this.c = c;
    life = 0;
  }

  public boolean move() {

    pos.add(move);

    List<Point> vecinos = new ArrayList();

    for (Panel p : cosa.getPanels()) {
      if (p.getCells() != null)
        for (Cell cell : p.getCells()) {
          for (int i =0; i<cell.polygon.size(); i++) {
            Point point = cell.polygon.get(i);
            PVector vp = new PVector(point.x, point.y);
            if (PVector.dist(vp, new PVector(mouseX, mouseY)) < 10) {
              //añadimos nueva partícula
              if (particulas.size() < 100) {
                addParticulas(cell, point, i);
                aniadidas = true;
              }
            }
          }
        }
    }

    boolean death = false;
    life++;
    if (life > maxLife) {
      println(frameCount+"muerte por viejo aniadidas"+aniadidas);
      death = true;
    }

    if (PVector.dist(pos, end) < 2) {
      println(frameCount+"muerte por llegar al fin aniadidas"+aniadidas);
      death =  true;
    }

    if (death && !aniadidas) {
      for (Panel p : cosa.getPanels()) {
        if (p.getCells() != null)
          for (Cell cell : p.getCells()) {
            for (int i =0; i<cell.polygon.size(); i++) {
              Point point = cell.polygon.get(i);
              PVector vp = new PVector(point.x, point.y);
              if (PVector.dist(vp, new PVector(mouseX, mouseY)) < 35) {
                //añadimos nueva partícula
                if (particulas.size() < 100 && random(10) > 5) {
                  addParticulas(cell, point, i);
                  aniadidas = true;
                }
              }
            }
          }
      }

      return false;
    }

    return true;
  }

  public void render(PGraphics canvas) {
    canvas.stroke(c);
    canvas.fill(c);
    canvas.ellipse(pos.x, pos.y, 1, 1);
  }
}