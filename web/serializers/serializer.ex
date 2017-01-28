defmodule VideoGrafikart.GuardianSerializer do

  @behaviour Guardian.Serializer

  alias MyApp.Repo
  alias MyApp.User

  def for_token(user = %{}), do: { :ok, "User:#{user.premium}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token(token), do: { :error, "Unknown resource type : " <> token }

end
