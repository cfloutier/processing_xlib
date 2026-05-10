class DataCircle extends GenericData
{
  DataCircle()
  {
    super("Circle");
  }

  float nb_lines    = 100;
  float circle_size = 400;
  float aspect_ratio = 1.0;
  int   seed        = 42;

  void LoadJson(JSONObject src)
  {
    if (src == null) return;
    nb_lines     = src.getFloat("nb_lines",     nb_lines);
    circle_size  = src.getFloat("circle_size",  circle_size);
    aspect_ratio = src.getFloat("aspect_ratio", aspect_ratio);
    seed         = src.getInt("seed",           seed);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();
    dest.setFloat("nb_lines",     nb_lines);
    dest.setFloat("circle_size",  circle_size);
    dest.setFloat("aspect_ratio", aspect_ratio);
    dest.setInt("seed",           seed);
    return dest;
  }
}


class CircleGUI extends GUIPanel
{
  DataCircle circle;

  Slider nb_lines;
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

    nb_lines     = addSlider("nb_lines",     "Nb Lines",     1, 1000);
    nextLine();
    circle_size  = addSlider("circle_size",  "Circle Size",  50, 2000);
    nextLine();
    aspect_ratio = addSlider("aspect_ratio", "Aspect Ratio", 0.1, 5.0);
  }

  void setGUIValues()
  {
    nb_lines.setValue(circle.nb_lines);
    circle_size.setValue(circle.circle_size);
    aspect_ratio.setValue(circle.aspect_ratio);
  }
}
