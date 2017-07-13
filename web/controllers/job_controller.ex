defmodule VideoGrafikart.JobController do

  use VideoGrafikart.Web, :controller

  @doc """
  Permet de relancer les tâches qui ont échouées
  """
  def failed(conn = %{method: "POST"}, _params) do
    Toniq.failed_jobs() |> Enum.map(&Toniq.retry(&1))
    redirect conn, external: job_path(conn, :failed)
  end

  @doc """
  Supprime les tâches qui ont réussie
  """
  def failed(conn = %{method: "DELETE"}, _params) do
    Toniq.failed_jobs() |> Enum.map(&Toniq.delete(&1))
    redirect conn, external: job_path(conn, :failed)
  end

  @doc """
  Affiche la liste des tâches qui ont échouée
  """
  def failed(conn = %{method: "GET"}, _params) do
    render conn, "failed.html", jobs: Toniq.failed_jobs()
  end

end
