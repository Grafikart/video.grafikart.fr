require IEx

defmodule VideoGrafikart.Video do

  def send_video(conn, path, headers) do
    full_path = get_video_path(path)
    offset = get_offset(headers)
    file_size = get_file_size(full_path)
    conn
      |> Plug.Conn.put_resp_header("content-type", "video/mp4")
      |> Plug.Conn.put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
      |> Plug.Conn.send_file(206, full_path, offset, file_size - offset)
  end

  # Renvois le chemin d'une vidéo'
  defp get_video_path(path) do
    Application.get_env(:video_grafikart, :video_path) |> Path.join(path)
  end

  # Renvois la taille du fichier
  defp get_file_size(path) do
    {:ok, %{size: size}} = File.stat(path)
    size
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