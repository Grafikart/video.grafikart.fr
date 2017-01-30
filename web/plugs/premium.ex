defmodule VideoGrafikart.Plugs.Premium do
  @moduledoc """
  Permet de s'assurer qu'un membre est bien premium
  """
  def init(opts \\ %{}), do: Enum.into(opts, %{})

  def call(conn, opts) do
    key = Map.get(opts, :key, :default)

    case Guardian.Plug.claims(conn, key) do
      {:ok, %{"premium" => premium}} -> check_premium(conn, premium)
      _ -> handle_error(conn)
    end
  end

  defp check_premium(conn, premium_end) do
    case premium_end > DateTime.to_unix(DateTime.utc_now()) do
      true -> conn
      false -> handle_error(conn)
    end
  end

  defp handle_error(conn) do
    conn
      |> Plug.Conn.resp(401, "not premium")
      |> Plug.Conn.halt()
  end

end
