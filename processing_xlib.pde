import controlP5.*;
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;

CircleLinesData data;
DataGUI dataGui;

PGraphics current_graphics;
ControlP5 cp5;

ArrayList<PVector[]> lines = new ArrayList<PVector[]>();

void setup()
{
  size(1200, 800);
  pixelDensity(1);
  surface.setResizable(true);

  data = new CircleLinesData();
  dataGui = new DataGUI(data);

  setupControls();

  data.LoadSettings("./Settings/default.json");
  dataGui.setGUIValues();
}

void setupControls()
{
  cp5 = new ControlP5(this);
  cp5.getTab("default").setLabel("Hide GUI");
  dataGui.Init();
}

void draw()
{
  start_draw();

  boolean circle_changed = data.circle.changed;
  data.reset_all_changes();

  if (circle_changed)
    buildLines();

  for (PVector[] l : lines)
    line(l[0].x, l[0].y, l[1].x, l[1].y);

  end_draw();

  dataGui.draw();
}

void buildLines()
{
  lines.clear();
  randomSeed((long)data.circle.seed);
  float r  = data.circle.circle_size / 2.0;
  float ar = data.circle.aspect_ratio;
  float rx = r * ar;
  float ry = r / ar;
  int n = (int)data.circle.nb_lines;
  for (int i = 0; i < n; i++)
  {
    float a1 = random(TWO_PI);
    float a2 = random(TWO_PI);
    lines.add(new PVector[] {
      new PVector(cos(a1) * rx, sin(a1) * ry),
      new PVector(cos(a2) * rx, sin(a2) * ry)
    });
  }
}
