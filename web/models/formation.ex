defmodule VideoGrafikart.Formation do

  use VideoGrafikart.Web, :model

  schema "formations" do
    field :name, :string
    field :slug, :string
  end

end
