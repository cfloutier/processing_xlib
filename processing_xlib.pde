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

  float[] clipped = new float[4];
  for (PVector[] l : lines) {
    if (data.page.clipping) {
      if (clipLineToCenteredRect(l[0].x, l[0].y, l[1].x, l[1].y,
                                 0, 0, data.page.clip_width, data.page.clip_height, clipped))
        current_graphics.line(clipped[0], clipped[1], clipped[2], clipped[3]);
    } else {
      current_graphics.line(l[0].x, l[0].y, l[1].x, l[1].y);
    }
  }

  end_draw();

  dataGui.draw();
}

void buildLines()
{
  lines.clear();
  BoundingBox bbox = new BoundingBox();
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
    PVector p1 = new PVector(cos(a1) * rx, sin(a1) * ry);
    PVector p2 = new PVector(cos(a2) * rx, sin(a2) * ry);
    lines.add(new PVector[] { p1, p2 });
  }

  // Bbox based on clip rect when active, otherwise on drawn content
  if (data.page.clipping) {
    bbox.addPoint(new PVector(-data.page.clip_width / 2, -data.page.clip_height / 2));
    bbox.addPoint(new PVector( data.page.clip_width / 2,  data.page.clip_height / 2));
  } else {
    float[] clipped = new float[4];
    for (PVector[] l : lines) {
      bbox.addPoint(l[0]);
      bbox.addPoint(l[1]);
    }
  }
  file_ui.updateExportScale(bbox);
}
