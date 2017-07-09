defmodule VideoGrafikart.RetryOnce do
  @moduledoc """
  The simplest retry strategy:
  """

  def retry?(attempt) when attempt <= 0, do: true
  def retry?(_attempt), do: false

  def ms_to_sleep_before(_attempt), do: 0 # no waiting between attempts
end
