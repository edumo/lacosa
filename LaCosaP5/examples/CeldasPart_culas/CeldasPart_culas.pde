/**
 * 
 * @authors Yago Tooroja, Enrique Esteban, Jorge Cano, Eduardo Moriana
 *
 *  Example using cells
 *  
 */

import org.mlp.cosa.Cell;
import org.mlp.cosa.Cosa;
import org.mlp.cosa.Point;
import org.mlp.cosa.Panel;
import org.mlp.cosa.Panels;
import java.util.*;

Cosa cosa;

CosaRender render;


private int[] indiceCeldas;

Cell lastCell;

List<Particula> particulas;
List<PVector> vertices;

boolean clear = false;

public void setup() {
  size(1024, 768);

  frameRate(60);

  cosa = new Cosa();
  File pathP = sketchFile("paneles.txt");
  File pathC = sketchFile("CoordCeldas.txt");
  cosa.init(pathP, pathC);

  render = new CosaRender();
  particulas = new ArrayList();


  indiceCeldas = new int[cosa.getPanels().size()];
}

public void draw() {

  background(0);

  fill(255);
  text("particulas"+particulas.size()+" "+ frameRate, 10, 10);

  cosa.setColor(255);

  render.render(cosa, g);

  List<Particula> particulasParaBorrar = new ArrayList();
 // println("redner");
  for (int i = 0; i<particulas.size(); i++) {
    Particula p = particulas.get(i);
    if (!p.move()) {
      particulasParaBorrar.add(p);
    }

    p.render(g);
  }
  //println("añadiendo particulas");
  particulas.removeAll(particulasParaBorrar);

  if (mousePressed) {
    println(mousePressed);
    for (Panel p : cosa.getPanels()) {
      if (p.getCells() != null)
        for (Cell cell : p.getCells()) {
          for (int i =0; i<cell.polygon.size(); i++) {
            Point point = cell.polygon.get(i);
            PVector vp = new PVector(point.x, point.y);
            if (PVector.dist(vp, new PVector(mouseX, mouseY)) < 5) {
              //añadimos nueva partícula
              println(frameCount+"ñadimos nueva partícula");
              addParticulas(cell, point, i);
            }
          }
        }
    }
  }
}

public void addParticulas(Cell cell, Point point, int i) {
  //vertices contíguos
  int ianterior = i-1;
  int iposterior = i+1;
  //miramos no nos salimos, hacemos lista circular
  if (ianterior < 0)
    ianterior = cell.polygon.size()-1;
  iposterior = iposterior % cell.polygon.size();
  //ya tenemos las posiciones anterior y posterior
  Point nextVertex = cell.polygon.get(iposterior);
  Point prevVertex = cell.polygon.get(ianterior);
  //ahora calculamos los vetores de movimiento
  PVector pos = new PVector(point.x, point.y);
  PVector move = PVector.sub(new PVector(nextVertex.x, nextVertex.y), pos);
  PVector move2 = PVector.sub(new PVector(prevVertex.x, prevVertex.y), pos);
  move.normalize();
  move2.normalize();

  Particula particula = new Particula();
  particula.init(pos, new PVector(nextVertex.x, nextVertex.y), move, color(255, 0, 0));
  particulas.add(particula);

  Particula particula2 = new Particula();
  particula2.init(pos, new PVector(prevVertex.x, prevVertex.y), move2, color(255, 0, 0));
  particulas.add(particula);
}

public void mousePressed() {
} 

public void keyPressed() {
  if (key == ' ') {
    clear = !clear;
    if (clear) {
      cosa.setIsDraw(false);
    }
  }
}