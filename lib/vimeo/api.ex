defmodule Vimeo.API do
  @moduledoc """
  Permet de communiquer avec l'API de Vimeo (simplement l'upload de vidéos)
  """

  use HTTPoison.Base
  use API.JsonApi

  def create(video) do
    size = File.stat!(video).size
    free = get!("/me").body["upload_quota"]["space"]["free"]
    if size < free do
      upload_video(video)
    else
      raise "Vimeo quota exceeded"
    end
  end

  @spec upload_video(String.t):: String.t
  defp upload_video(video) do
    size = File.stat!(video).size
    [upload_link, complete_uri] = get_upload_link()
    put!(upload_link, {:file, video}, [
      {"Content-Length", size},
      {"Content-Type", "video/mp4"}
    ])
    "bytes=0-" <> uploaded_size = put!(upload_link, "", [{"Content-Range", "bytes */*"}]).headers |> Enum.into(%{}) |> Map.get("Range")
    if size == String.to_integer(uploaded_size) do
      delete_upload(complete_uri)
    else
      raise "Upload incomplet de la vidéo " <> video
    end
  end

  @spec get_upload_link():: [String.t]
  defp get_upload_link() do
    body = post!("/me/videos", %{type: "streaming"}, ["Content-Type": "application/json;"]).body
    [body["upload_link_secure"], body["complete_uri"]]
  end

  @spec delete_upload(String.t):: String.t
  defp delete_upload(uri) do
    "/videos/" <> video_id = delete!(uri).headers |> Enum.into(%{}) |> Map.get("Location")
    video_id
  end

  defp process_url(url = "https" <> _), do: url
  defp process_url(url), do: "https://api.vimeo.com" <> url

end
