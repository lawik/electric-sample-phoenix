defmodule AdminWeb.ErrorHTMLTest do
  use AdminWeb.ConnCase, async: true

  # Bring render_to_string/3 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(AdminWeb.ErrorHTML, "404", "html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(AdminWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
