defmodule Youtube.API do
  @moduledoc """
  Permet de communiquer avec l'API de youtube
  """

  @type parts :: %{snippet: map, status: map}

  use HTTPoison.Base

  @doc """
  Génère un access_token depuis le refresh token
  """
  @spec get_access_token():: String.t
  def get_access_token() do
    config = Application.get_env(:video_grafikart, :youtube)
    # On récupère l'access token
    {:ok, %{body: %{"access_token" => access_token}}} = post("oauth2/v4/token", {:form, config ++ [grant_type: "refresh_token"]})
    access_token
  end

  @doc """
  Upload une vidéo
  """
  @spec upload(String.t, parts, []):: %HTTPoison.Response{}
  def upload(video, parts, headers) do
    %{headers: response} = post!(
      "upload/youtube/v3/videos?uploadType=resumable&part=snippet,status",
      parts,
      headers ++ [{"Content-Type", "application/json"}]
    )
    location = response |> Enum.into(%{}) |> Map.get("Location")
    put!(location, {:file, video})
  end

  @doc """
  Permet d'associer une image a une vidéo
  """
  @spec thumbnail(String.t, String.t, []):: %HTTPoison.Response{}
  def thumbnail(id, thumbnail, headers) do
    location = "upload/youtube/v3/thumbnails/set?videoId=#{id}&uploadType=resumable"
      |> post!("", headers)
      |> Map.get(:headers)
      |> Enum.into(%{})
      |> Map.get("Location")
    %{status_code: 200} = post!(location, {:file, thumbnail}, [{"Content-Type", "image/jpg"}])
  end

  @doc """
  Met à jour les informations associées à une vidéo
  """
  @spec update(String.t, parts, []):: %HTTPoison.Response{}
  def update(id, parts, headers) do
    parts = parts |> Map.merge(%{id: id})
    put!("youtube/v3/videos?part=snippet,status", parts, headers ++ [{"Content-Type", "application/json"}])
  end


  defp process_url(url = "https://" <> _), do: url
  defp process_url(url), do: "https://www.googleapis.com/" <> url

  defp process_request_body(body) when is_map(body), do: Poison.encode!(body)
  defp process_request_body(body), do: body

  defp process_response_body(body) do
    case Poison.decode(body) do
      {:ok, json} -> json
      _ -> body
    end
  end

end