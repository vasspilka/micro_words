defmodule MicroWordsWeb.PageLiveTest do
  use MicroWordsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Hello explorer!"
    assert render(page_live) =~ "Hello explorer!"
  end
end
