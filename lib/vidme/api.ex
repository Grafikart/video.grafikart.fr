defmodule Vidme.API do
  @moduledoc """
  Permet de communiquer avec l'API de Vidme (simplement l'upload de vidéos)
  """

  use HTTPoison.Base

  @doc """
  Permet d'uploader une video auprès de l'API
  """
  @spec upload(%{title: String.t, file: String.t, description: String.t, }):: {:ok, %{vidme_id: String.t, vidme_url: String.t}}
  def upload(video) do
    {:ok, %{body: body}} = post(
      "video/upload",
      {:multipart, [
        {"title", video.title},
        {"description", video.description},
        {"private", "0"},
        {:file, video.file, {"form-data", [name: "filedata", filename: Path.basename(video.file)]}, []},
        {:file, video.thumbnail, {"form-data", [name: "thumbnail", filename: Path.basename(video.thumbnail)]}, []}
      ]},
      [recv_timeout: 30000]
    )
    %{"id" => video_id, "code" => video_url} = Poison.decode!(body)
    {:ok, %{vidme_id: video_id, vidme_url: video_url}}
  end

  defp process_url(url) do
    "https://api.vid.me/" <> url
  end

  defp process_request_headers(headers) do
    access_token = Application.get_env(:video_grafikart, :vidme) |> Keyword.get(:access_token)
    headers ++ ["AccessToken": access_token]
  end

end
