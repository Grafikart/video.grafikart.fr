defmodule Vidme.APITest do

  use VideoGrafikart.ConnCase

  # import Ecto.Query, only: [from: 2]

  alias Vidme.API

  def get_videos_from_api(offset \\ 0) do
    {:ok, %{body: %{"videos" => videos}}} = API.get("videos/?user=16979442&offset=#{offset}&limit=100")
    videos |> Enum.filter(fn(video) -> Map.get(video, "state") != "failed" end) |> IO.inspect
    ids = videos |> Enum.map(&Map.get(&1, "video_id"))
    if Enum.count(videos) > 0 do
      ids ++ get_videos_from_api(offset + 100)
    else
      ids
    end
  end

  def delete_failed() do
    {:ok, %{body: %{"videos" => videos}}} = API.get("videos/?user=16979442limit=100&state=failed")
    videos |> Enum.map(&Map.get(&1, "video_id")) |> Enum.map(&Vidme.API.delete(&1))
  end

  @tag :skip
  test "it should return the body" do
    # Vidme.Worker.perform(21)
    %{body: %{"videos" => videos}} = API.get!("videos/?user=16979442&limit=1")
    assert Enum.count(videos) == 1
    # videos = get_videos_from_api() |> Enum.map(())
    # delete_failed()
    # query = from t in VideoGrafikart.Tutoriel, where: not is_nil(t.vidme_id)
    # db_ids = VideoGrafikart.Repo.all(query) |> Enum.map(fn(video) -> video.vidme_id end)
    # vidme_ids = get_videos_from_api
    # vidme_ids |> Enum.count() |> IO.inspect()
    # (db_ids -- vidme_ids) |> Enum.map(&String.to_integer(&1)) |> IO.inspect()
  end

end