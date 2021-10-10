defmodule MicroWordsWeb.PageLiveTest do
  use MicroWordsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
    assert render(page_live) =~ "Select a world"
  end
end
