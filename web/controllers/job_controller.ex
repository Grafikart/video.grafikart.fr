defmodule VideoGrafikart.JobController do

  use VideoGrafikart.Web, :controller

  def failed(conn = %{method: "POST"}, _params) do
    Toniq.failed_jobs() |> Enum.map(&Toniq.retry(&1))
    redirect conn, external: job_path(conn, :failed)
  end

  def failed(conn = %{method: "GET"}, _params) do
    render conn, "failed.html", jobs: Toniq.failed_jobs()
  end

end
