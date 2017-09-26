defmodule VideoGrafikart.Video do
  
    @type range :: %{start: integer, end: integer, size: integer}
  
    @doc """
    Permet de renvoyer une vidéo
    """
    @spec send_video(Plug.Conn.t, String.t, []) :: Plug.Conn.t
    def send_video(conn, path, headers) do
      if is_valid?(path) do
        full_path = get_video_path(path)
        case get_file_size(full_path) do
          :error ->
            conn |> Plug.Conn.resp(404, "video not found")
          file_size ->
            range = get_range(headers, file_size)
            conn
              |> Plug.Conn.put_resp_header("accept-ranges", "bytes")
              |> Plug.Conn.put_resp_header("content-length", "#{range.size}")
              |> Plug.Conn.put_resp_header("content-type", "video/mp4")
              |> Plug.Conn.put_resp_header("content-range", "bytes #{range.start}-#{range.end}/#{file_size}")
              |> Plug.Conn.send_file(206, full_path, range.start, range.size)
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
      Application.get_env(:video_grafikart, :paths)
        |> Keyword.get(:video)
        |> Path.join(trimmed_path)
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
    # Range:bytes=0-1
    @spec get_range(list(tuple), integer) :: range
    defp get_range(headers, file_size) do
      case List.keyfind(headers, "range", 0) do
        {"range", "bytes=" <> range} -> 
          [range_start, range_end] = String.split(range, "-") |> Enum.map(&to_integer/1)
          range_end = if range_end == nil, do: file_size, else: range_end
          %{start: range_start, end: range_end, size: range_end - range_start + 1}
        nil -> %{start: 0, end: file_size, size: file_size}
      end
    end
  
    # Return byte as an integer (or nil)
    def to_integer(byte) do
      case byte do
        "" -> nil
        _  -> String.to_integer(byte)
      end
    end
  
  
  end
  