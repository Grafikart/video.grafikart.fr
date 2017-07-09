defmodule VideoGrafikart.Category do

  use VideoGrafikart.Web, :model

  schema "categories" do
    field :name, :string
    field :slug, :string

    has_many :tutoriels, VideoGrafikart.Tutoriel
  end

end
