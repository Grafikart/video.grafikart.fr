defmodule VideoGrafikart.VideoControllerTest do

  use VideoGrafikart.ConnCase

  import VideoGrafikart.Router.Helpers, only: [video_path: 3]

  defp now do
     DateTime.utc_now() |> DateTime.to_unix()
  end

  defp jwt(data = %{}) do
    claims = Guardian.Claims.app_claims
         |> Map.merge(data)
         |> Guardian.Claims.ttl({3, :days})
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(%{}, :access, claims)
    jwt
  end

  test "it should refuse connection without the right JWT", %{conn: conn} do
    conn = get conn, video_path(conn, :stream, path: "fake.mp4", token: "fake_token")
    assert text_response(conn, 401)
  end

  test "it should reject people that are not premiums", %{conn: conn} do
    path = video_path conn, :stream, path: "fake.mp4", token: jwt(%{premium: now() - 1000})
    conn = get conn, path
    assert response(conn, 401)
  end

  test "it should accept a valid JWT", %{conn: conn} do
    path = video_path conn, :stream, path: "fake.mp4", token: jwt(%{premium: now() + 1000})
    conn = get conn, path
    %{resp_headers: resp_headers} = conn
    assert response(conn, 206)
    assert {"content-range", "bytes 0-5/6"} in resp_headers
    assert response_content_type(conn, :mp4)
  end

  test "it should detect if a file doesn't exist", %{conn: conn} do
    path = video_path conn, :stream, path: "../test_helper.exs", token: jwt(%{premium: now() + 1000})
    conn = get conn, path
    assert response(conn, 404)  =~ "not found"
  end

end
