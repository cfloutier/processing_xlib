import controlP5.*;
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;

CircleLinesData data;
DataGUI dataGui;

PGraphics current_graphics;
ControlP5 cp5;

PolylineGroup lineGroup = new PolylineGroup();

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
  boolean page_changed   = data.page.changed;
  data.reset_all_changes();

  if (circle_changed || page_changed)
    buildLines();

  // Debug: draw clipping rect border
  //if (data.page.clipping) {
  //  current_graphics.noFill();
  //  current_graphics.stroke(data.style.lineColor.col);
  //  current_graphics.rect(-data.page.clip_width / 2, -data.page.clip_height / 2,
  //                         data.page.clip_width, data.page.clip_height);
  //}

  lineGroup.draw(data.page.clipping, data.page.clip_width, data.page.clip_height);

  end_draw();

  dataGui.draw();
}

void buildLines()
{
  lineGroup.clear();
  randomSeed((long)data.circle.seed);
  float rx = (data.circle.circle_size / 2.0) * data.circle.aspect_ratio;
  float ry = (data.circle.circle_size / 2.0) / data.circle.aspect_ratio;
  int nPoly   = (int)data.circle.nb_polylines;
  int ptsMin  = max(2, (int)data.circle.nb_points_min);
  int ptsMax  = max(ptsMin, (int)data.circle.nb_points_max);

  for (int i = 0; i < nPoly; i++)
  {
    int nPts = (int)random(ptsMin, ptsMax + 1);
    Polyline seg = new Polyline();
    for (int j = 0; j < nPts; j++)
    {
      float a = random(TWO_PI);
      seg.addPoint(new PVector(cos(a) * rx, sin(a) * ry));
    }
    lineGroup.add(seg);
  }
  file_ui.updateExportScale(lineGroup.getBoundingBox(data.page.clipping, data.page.clip_width, data.page.clip_height));
}
