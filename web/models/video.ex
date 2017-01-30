require IEx

defmodule VideoGrafikart.Video do

  def send_video(conn, path, headers) do
    full_path = get_video_path(path)
    offset = get_offset(headers)
    case get_file_size(full_path) do
      :error ->
        conn
          |> Plug.Conn.resp(404, "video not found")
          |> Plug.Conn.halt()
      file_size ->
        conn
          |> Plug.Conn.put_resp_header("content-type", "video/mp4")
          |> Plug.Conn.put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
          |> Plug.Conn.send_file(206, full_path, offset, file_size - offset)
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
