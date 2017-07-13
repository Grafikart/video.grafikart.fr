defmodule Youtube.Worker do
  @moduledoc """
  Worker responsable de l'envoie d'une vidéo sur youtube
  """

  require Logger

  use Toniq.Worker, max_concurrency: 3

  alias VideoGrafikart.Tutoriel
  alias VideoGrafikart.Repo
  alias Youtube.API

  @spec perform(integer):: atom
  def perform(id) do
    Logger.info("Youtube::Upload #{id}")
    # On récupère la vidéo
    tutoriel = Repo.get(Tutoriel, id) |> Repo.preload([:category, :formation])
    thumbnail = Tutoriel.thumbnail_path(tutoriel)
    video = Tutoriel.video_path(tutoriel)
    parts = to_parts(tutoriel)
    # On récupère le token d'accès
    headers = ["Authorization": "Bearer #{API.get_access_token()}"]
    tutoriel = if is_nil(tutoriel.youtube) || tutoriel.youtube == "" do
      # On lance l'upload de la vidéo
      %{body: %{"id" => youtube_id}} = API.upload(video, parts, headers)
      # On persiste l'id de la vidéo en base
      tutoriel |> Ecto.Changeset.change(%{youtube: youtube_id}) |> Repo.update!()
    else
      # On met à jour les informations
      %{body: _} = API.update(tutoriel.youtube, parts, headers)
      tutoriel
    end
    # On upload la miniature
    API.thumbnail(tutoriel.youtube, thumbnail, headers)
    Logger.info("/Youtube::Upload #{id}::#{tutoriel.name}")
  end

  @doc """
  Prepare les données pour l'API de youtube
  """
  @spec to_parts(%Tutoriel{}):: %{}
  def to_parts(tutoriel) do
    %{
      snippet: %{
        title: Tutoriel.title(tutoriel),
        description: Tutoriel.description(tutoriel),
        categoryId: "28",
        defaultLanguage: "fr",
        defaultAudioLanguage: "fr"
      },
      status: %{
        privacyStatus: if Map.get(tutoriel, :online, false) do "public" else "unlisted" end,
        embeddable: true,
        publicStatsViewable: false
      }
    }
  end

end