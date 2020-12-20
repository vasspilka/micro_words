defmodule MicroWordsWeb.PageLiveTest do
  use MicroWordsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "You are at:"
    assert render(page_live) =~ "{1,1:dev_world}"
  end
end
