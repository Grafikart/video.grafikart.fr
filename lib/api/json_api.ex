defmodule API.JsonApi do

  defmacro __using__(_) do
    quote do
      defp process_request_headers(headers) do
        access_token = Application.get_env(:video_grafikart, :vimeo) |> Keyword.get(:access_token)
        headers ++ ["Authorization": "Bearer " <> access_token]
      end

      defp process_request_body(body) when is_map(body), do: Poison.encode!(body)
      defp process_request_body(body), do: body

      defp process_response_body(body) do
        case Poison.decode(body) do
          {:ok, json} -> json
          _ -> body
        end
      end
    end
  end

end