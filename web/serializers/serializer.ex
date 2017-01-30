defmodule VideoGrafikart.GuardianSerializer do

  @behaviour Guardian.Serializer

  def for_token(data = %{}), do: { :ok, data }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token(data), do: { :ok, data }
end
