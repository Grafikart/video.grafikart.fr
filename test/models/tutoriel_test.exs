defmodule VideoGrafikart.TutorielTest do

  use VideoGrafikart.ConnCase

  alias VideoGrafikart.Tutoriel
  alias VideoGrafikart.Category
  alias VideoGrafikart.Formation

  @tutoriel %Tutoriel{
    id: 189,
    name: "Tutoriel de Test",
    video: "video.mp4",
    content: """
    This is the first paragraph

    This is the second paragraph
    """,
    category: %Category{
      name: "Categorie de test",
      slug: "category-test"
    },
    formation: nil
  }

  @tutoriel_with_formation Map.merge(@tutoriel, %{
    formation: %Formation{
      name: "Formation de test",
      slug: "formation-test",
      chapters: "Introduction=837,838,839,840,841
        Controllers=842,189,844"
    }
  })

  test "it should return a valid title" do
    assert Tutoriel.title(@tutoriel) == "Tutoriel #{@tutoriel.category.name} : #{@tutoriel.name}"
    assert Tutoriel.title(@tutoriel_with_formation) == "#{@tutoriel_with_formation.formation.name} 7/_ : #{@tutoriel_with_formation.name}"
  end

  test "it should get the right position" do
    assert Tutoriel.position(@tutoriel_with_formation) == "7/_"
  end

  test "it should return a good url" do
    assert Tutoriel.url(@tutoriel) == "https://www.grafikart.fr/tutoriels/#{@tutoriel.category.slug}/#{@tutoriel.slug}-#{@tutoriel.id}"
    assert Tutoriel.url(@tutoriel_with_formation) == "https://www.grafikart.fr/formations/#{@tutoriel_with_formation.formation.slug}/#{@tutoriel_with_formation.slug}"
  end

  test "it should return the good thumbnail_path" do
    t = @tutoriel
    path = Application.get_env(:video_grafikart, :paths) |> Keyword.get(:thumbnail)
    assert Tutoriel.thumbnail_path(t) == Path.join(path, "/1/#{t.id}.jpg")
    t = Map.merge(t, %{id: 1234})
    assert Tutoriel.thumbnail_path(t) == Path.join(path, "/2/#{t.id}.jpg")
  end

  test "it should return the right video path" do
    path = Application.get_env(:video_grafikart, :paths) |> Keyword.get(:video)
    assert Tutoriel.video_path(@tutoriel) == Path.join(path, @tutoriel.video)
  end

  test "it should get the first paragraph" do
    assert Tutoriel.first_paragraph(@tutoriel) == "This is the first paragraph"
    t = Map.put(@tutoriel, :content, "fake\r\n\r\ncontent")
    assert Tutoriel.first_paragraph(t) == "fake"
  end

end
