defmodule VideoGrafikart.VideoController do

  use VideoGrafikart.Web, :controller
  alias VideoGrafikart.Video

  plug VideoGrafikart.Plugs.VerifyQuery
  plug Guardian.Plug.EnsureAuthenticated
  plug VideoGrafikart.Plugs.Premium

  def stream(conn = %{req_headers: headers}, %{"path" => path}) do
    Video.send_video(conn, path, headers)
  end

end
