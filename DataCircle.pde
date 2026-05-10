class DataCircle extends GenericData
{
  DataCircle()
  {
    super("Circle");
  }

  float nb_polylines      = 20;
  float nb_points_min     = 2;
  float nb_points_max     = 10;
  float circle_size       = 400;
  float aspect_ratio      = 1.0;
  int   seed              = 42;

  void LoadJson(JSONObject src)
  {
    if (src == null) return;
    nb_polylines     = src.getFloat("nb_polylines",  nb_polylines);
    nb_points_min    = src.getFloat("nb_points_min", nb_points_min);
    nb_points_max    = src.getFloat("nb_points_max", nb_points_max);
    circle_size      = src.getFloat("circle_size",   circle_size);
    aspect_ratio     = src.getFloat("aspect_ratio",  aspect_ratio);
    seed             = src.getInt("seed",             seed);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();
    dest.setFloat("nb_polylines",  nb_polylines);
    dest.setFloat("nb_points_min", nb_points_min);
    dest.setFloat("nb_points_max", nb_points_max);
    dest.setFloat("circle_size",   circle_size);
    dest.setFloat("aspect_ratio",  aspect_ratio);
    dest.setInt("seed",            seed);
    return dest;
  }
}


class CircleGUI extends GUIPanel
{
  DataCircle circle;

  Slider nb_polylines;
  Slider nb_points_min;
  Slider nb_points_max;
  Slider circle_size;
  Slider aspect_ratio;

  CircleGUI(DataCircle circle)
  {
    super("Circle", circle);
    this.circle = circle;
  }

  void setupControls()
  {
    super.Init();

    nb_polylines  = addSlider("nb_polylines",  "Nb Polylines",   1, 500);
    nextLine();
    nb_points_min = addSlider("nb_points_min", "Pts Min",         2, 20);
    nextLine();
    nb_points_max = addSlider("nb_points_max", "Pts Max",         2, 20);
    nextLine();
    circle_size   = addSlider("circle_size",   "Circle Size",    50, 2000);
    nextLine();
    aspect_ratio  = addSlider("aspect_ratio",  "Aspect Ratio",  0.1, 5.0);
  }

  void setGUIValues()
  {
    nb_polylines.setValue(circle.nb_polylines);
    nb_points_min.setValue(circle.nb_points_min);
    nb_points_max.setValue(circle.nb_points_max);
    circle_size.setValue(circle.circle_size);
    aspect_ratio.setValue(circle.aspect_ratio);
  }
}
