defmodule VideoGrafikart.Tutoriel do

  use VideoGrafikart.Web, :model

  alias VideoGrafikart.Category
  alias VideoGrafikart.Formation

  schema "tutoriels" do
    field :name, :string
    field :video, :string
    field :content, :string
    field :slug, :string
    field :vidme_id, :string
    field :vidme_url, :string
    field :user_id, :integer
    field :premium, :boolean
    field :online, :boolean
    field :youtube, :string
    field :created_at, :utc_datetime

    belongs_to :category, Category
    belongs_to :formation, Formation
  end

  @doc """
  Renvoie le titre d'un tutoriel
  """
  @spec title(%__MODULE__{name: String.t, category: %Category{name: String.t}}):: String.t
  def title(tutoriel = %__MODULE__{name: name, category: %Category{name: category}}) do
    if tutoriel.formation do
      [index, total] = position(tutoriel)
      "#{tutoriel.formation.name} (#{index}/#{total}) : #{name}"
    else
      "Tutoriel #{category} : #{name}"
    end
  end

  @spec description(%__MODULE__{}):: String.t
  def description(tutoriel) do
    """
    Plus d'infos : #{url(tutoriel)}

    #{first_paragraph(tutoriel)}

    Retrouvez tous les tutoriels sur https://www.grafikart.fr
    """
  end

  @doc """
  Renvoie l'url d'un tutoriel
  """
  @spec url(%__MODULE__{slug: String.t, id: integer, category: %Category{slug: String.t}}):: String.t
  def url(tutoriel = %__MODULE__{slug: slug, id: id, category: %Category{slug: category_slug}}) do
    ids = Integer.to_string(id)
    if tutoriel.formation do
      "https://www.grafikart.fr/formations/#{tutoriel.formation.slug}/#{slug}"
    else
      "https://www.grafikart.fr/tutoriels/#{category_slug}/#{slug}-#{ids}"
    end
  end

  @doc """
  Renvoie le chemin du fichier contenant la miniature
  """
  @spec video_path(%__MODULE__{video: String.t}):: String.t
  def video_path(%__MODULE__{video: video}) do
    Application.get_env(:video_grafikart, :paths)
      |> Keyword.get(:video)
      |> Path.join(video)
  end

  @doc """
  Renvoie le chemin du fichier contenant la miniature
  """
  @spec thumbnail_path(%__MODULE__{id: integer}):: String.t
  def thumbnail_path(%__MODULE__{id: id}) do
    thumbnail_name = Integer.to_string(id) <> ".jpg"
    directory = id |> Kernel.div(1000) |> Kernel.+(1) |> Integer.to_string()
    Application.get_env(:video_grafikart, :paths)
      |> Keyword.get(:thumbnail)
      |> Path.join(directory)
      |> Path.join(thumbnail_name)
  end

  @doc """
  Renvoie le premier paragraphe du contenu
  """
  @spec first_paragraph(%__MODULE__{content: String.t}):: String.t
  def first_paragraph(%__MODULE__{content: content}) do
    content |> String.split(~r"(\r\n|\r|\n){2}") |> List.first
  end

  @doc """
  Renvoie la position de la vidéo dans une formation
  """
  @spec position(%__MODULE__{formation: %{chapters: String.t}}):: [integer]
  def position(%__MODULE__{id: id, formation: %{chapters: chapters}}) do
    chapters = String.split(chapters,  ["\n", "\r", "\r\n"])
      |> Enum.map(fn chapter -> 
        [_, videos] = String.split(chapter, "=")
        String.split(videos, ",")
      end)
      |> List.flatten()
    index = Enum.find_index(chapters, fn video_id -> video_id == to_string(id) end) + 1
    count = Enum.count(chapters)
    [index, count]
  end
  
  @doc """
  La vidéo est public ?
  """
  @spec public?(%__MODULE__{}):: boolean
  def public?(%__MODULE__{created_at: created_at}) do
    DateTime.compare(DateTime.utc_now, created_at) == :gt
  end

  @doc """
  Renvoie le changeset
  """
  @spec changeset(struct, struct):: Ecto.Changeset.t
  def changeset(struct, params \\ %{}) do
    struct |> cast(params, [:vidme_id, :vidme_url])
  end



end
