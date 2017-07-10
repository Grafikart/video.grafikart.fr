defmodule Vidme.API do
  @moduledoc """
  Permet de communiquer avec l'API de Vidme (simplement l'upload de vidéos)
  """

  use HTTPoison.Base

  @doc """
  Permet de supprimer toutes les vidéos
  """
  @spec delete_all():: []
  def delete_all() do
    {:ok, %{body: body}} = get("videos/list?user=16979442&limit=461")
    %{"videos" => videos} = Poison.decode!(body)
    ids = videos |> Enum.map(&Map.get(&1, "video_id")) |> Enum.map(&delete(&1))
  end

  @doc """
  Supprimer une vidéo VidMe
  """
  @spec delete(String.t):: :ok
  def delete(video_id) when is_binary(video_id) do
    :timer.sleep(100)
    {:ok, %{body: body}} = post("video/#{video_id}/delete", {:form, [video: video_id]})
    :ok
  end

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
