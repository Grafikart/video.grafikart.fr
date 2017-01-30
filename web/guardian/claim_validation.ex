defmodule VideoGrafikart.Guardian.ClaimValidation do

  @moduledoc false
  @behaviour Guardian.ClaimValidation

  use Guardian.ClaimValidation

  @doc """
  We force expiration time to be defined on module
  """
  def validate_claim(_, payload, _) do
    case Map.get(payload, "exp") do
      nil -> {:error, :token_expired}
      _ -> :ok
    end
  end

end
