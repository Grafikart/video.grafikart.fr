defmodule Vidme.Worker do
  @moduledoc """
  Worker responsable de l'envoie d'une vidéo sur vidme
  """

  require Logger

  use Toniq.Worker, max_concurrency: 1

  alias VideoGrafikart.Tutoriel
  alias VideoGrafikart.Repo
  alias VideoGrafikart.VideoUpload
  alias Vidme.API

  @doc """
  Gère l'envoie d'une vidéo sur vidme
  """
  @spec perform(integer):: atom
  def perform(id) do
    Logger.info("...Sending tutoriel #{id}")
    # On récupère la vidéo
    tutoriel = Repo.get(Tutoriel, id) |> Repo.preload([:category, :formation])
    thumbnail = Tutoriel.thumbnail_path(tutoriel)
    # La vidéo n'est pas déjà présente sur vidme
    if is_nil(tutoriel.vidme_id) do
      # On upload la vidéo
      {:ok, %{body: %{"id" => id, "code" => code}}} = API.upload(%{
        title: Tutoriel.title(tutoriel),
        description: Tutoriel.description(tutoriel),
        video: Tutoriel.video_path(tutoriel),
      })
      # On met à jour les identifiants en bdd
      {:ok, tutoriel} = tutoriel
        |> Ecto.Changeset.change(%{vidme_id: id, vidme_url: code})
        |> Repo.update()
      # On met à jour la miniature
      {:ok, %{body: body}} = API.thumbnail(tutoriel.vidme_id, thumbnail)
    else
      # On met à jour les informations
      {:ok, %{body: body}} = API.post("video/#{tutoriel.vidme_id}/edit", {:multipart, [
        {"title", Tutoriel.title(tutoriel)},
        {"description", Tutoriel.description(tutoriel)},
        {:file, thumbnail, {"form-data", [name: "thumbnail", filename: Path.basename(thumbnail)]}, []}
      ]})
    end
    Logger.info("Finished Sending #{id}::#{tutoriel.name}")
  end

end
