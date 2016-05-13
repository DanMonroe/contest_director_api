defmodule ContestDirectorApi.ErrorViewTest do
  use ContestDirectorApi.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ContestDirectorApi.ErrorView, "404.json", []) ==
           %{errors: [%{code: 500, title: "Internal Server Error"}]}
  end

  test "render 403.json" do
    assert render(ContestDirectorApi.ErrorView, "403.json", []) ==
           %{errors: [%{code: 403, title: "Forbidden"}]}
  end

  test "render 500.json" do
    assert render(ContestDirectorApi.ErrorView, "500.json", []) ==
           %{errors: [%{code: 500, title: "Internal Server Error"}]}
  end

  test "render any other" do
    assert render(ContestDirectorApi.ErrorView, "505.json", []) ==
           %{errors: [%{code: 500, title: "Internal Server Error"}]}
  end
end
