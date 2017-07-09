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

  def sync(conn, %{"token" => token}) do
    secret = Application.get_env(:guardian, Guardian) |> Keyword.get(:secret_key)
    if token == secret do
      query = from t in Tutoriel,
        where: t.user_id == 1 and t.video != "" and is_nil(t.vidme_id) and t.premium == false,
        order_by: [asc: t.id]
      Repo.all(query)
        |> Repo.preload([:category, :formation])
        |> Enum.map(fn(tutoriel) -> Toniq.enqueue(Vidme.Worker, tutoriel) end)
      text conn, "ok"
    else
      conn |> Plug.Conn.put_status(500) |> text("forbidden")
    end
  end

end
