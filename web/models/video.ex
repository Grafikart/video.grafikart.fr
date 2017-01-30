defmodule VideoGrafikart.Video do

  @doc """
  Permet de renvoyer une vidéo
  """
  @spec send_video(Plug.Conn.t, String.t, []) :: Plug.Conn.t
  def send_video(conn, path, headers) do
    if is_valid?(path) do
      full_path = get_video_path(path)
      offset = get_offset(headers)
      case get_file_size(full_path) do
        :error ->
          conn |> Plug.Conn.resp(404, "video not found")
        file_size ->
          conn
            |> Plug.Conn.put_resp_header("content-type", "video/mp4")
            |> Plug.Conn.put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
            |> Plug.Conn.send_file(206, full_path, offset, file_size - offset)
      end
    else
      conn |> Plug.Conn.resp(404, "video not found")
    end
  end

  @doc """
  Permet de vérifier si le chemin d'une vidéo valide
  """
  @spec is_valid?(String.t) :: boolean
  def is_valid?(path) do
     case Regex.run(~r/^([a-z0-9-_ ]+\/)?[a-z0-9-_ ]+\.(mp4|mov)$/i, path) do
        nil -> false
        _ -> true
     end
  end

  # Renvois le chemin d'une vidéo'
  defp get_video_path(path) do
    trimmed_path = path
      |> String.trim(".")
      |> String.trim("/")
    Application.get_env(:video_grafikart, :video_path) |> Path.join(trimmed_path)
  end

  # Renvois la taille du fichier
  defp get_file_size(path) do
    case File.stat(path) do
      {:ok, %{size: size}} -> size
      {:error, _} -> :error
    end
  end

  # Get byte offset from range header
  # Range:bytes=0-
  defp get_offset(headers) do
    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=" <> start_post} -> String.split(start_post, "-") |> hd |> String.to_integer
      nil -> 0
    end
  end


end
