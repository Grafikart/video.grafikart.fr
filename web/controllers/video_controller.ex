defmodule VideoGrafikart.VideoController do

  use VideoGrafikart.Web, :controller

  alias VideoGrafikart.Video
  alias VideoGrafikart.Tutoriel
  alias VideoGrafikart.Repo

  import Ecto.Query, only: [from: 2]

  plug VideoGrafikart.Plugs.VerifyQuery when action in [:stream]
  plug Guardian.Plug.EnsureAuthenticated when action in [:stream]
  plug VideoGrafikart.Plugs.Premium when action in [:stream]

  def stream(conn = %{req_headers: headers}, %{"path" => path}) do
    Video.send_video(conn, path, headers)
  end

  def sync(conn, %{"token" => token, "id" => id}) do
    secret = Application.get_env(:guardian, Guardian) |> Keyword.get(:secret_key)
    if token == secret do
      Toniq.enqueue(Youtube.Worker, id)
      conn |> text("Uploading #{id}")
    else
      conn |> Plug.Conn.put_status(500) |> text("forbidden")
    end
  end

end
