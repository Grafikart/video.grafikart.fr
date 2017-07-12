defmodule Vidme.API do
  @moduledoc """
  Permet de communiquer avec l'API de Vidme (simplement l'upload de vidéos)
  """

  use HTTPoison.Base

  @doc """
  Supprimer une vidéo VidMe
  """
  @spec delete(String.t):: :ok
  def delete(video_id) when is_binary(video_id) do
    post("video/#{video_id}/delete", {:form, [video: video_id]})
  end

  @doc """
  Permet d'uploader une video auprès de l'API
  """
  @spec upload(%{title: String.t, video: String.t, description: String.t}):: {:ok, %{vidme_id: String.t, vidme_url: String.t}}
  def upload(video) do
    {:ok, %{body: body}} = post(
      "video/upload",
      {:multipart, [
        {"title", video.title},
        {"description", video.description},
        {"private", "0"},
        {"source", "computer"},
        {:file, video.video, {"form-data", [name: "filedata", filename: Path.basename(video.video)]}, []},
      ]},
      [recv_timeout: 30000]
    )
  end

  @doc """
  Permet d'ajouter une thumbnail a une vidéo
  """
  @spec thumbnail(String.t, String.t):: tuple
  def thumbnail(video_id, thumbnail) do
    post("video/#{video_id}/thumbnail",{:multipart, [
      {"video", video_id},
      {:file, thumbnail, {"form-data", [name: "thumbnail", filename: Path.basename(thumbnail)]}, []}
    ]})
  end

  defp process_url(url) do
    "https://api.vid.me/" <> url
  end

  defp process_request_headers(headers) do
    access_token = Application.get_env(:video_grafikart, :vidme) |> Keyword.get(:access_token)
    headers ++ ["AccessToken": access_token]
  end

  defp process_response_body(body), do: Poison.decode!(body)

end
