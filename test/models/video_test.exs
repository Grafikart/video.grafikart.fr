defmodule VideoGrafikart.VideoTest do

  use VideoGrafikart.ConnCase

  alias VideoGrafikart.Video

  test "is_valid?: it should reject bad path" do
    assert Video.is_valid?("../test.mp4") == false
    assert Video.is_valid?("/test.mp4") == false
  end

  test "is_valid?: it should reject deep path" do
    assert Video.is_valid?("path/deep/test.mp4") == false
  end

  test "is_valid?: it should allow path" do
    assert Video.is_valid?("test.mp4") == true
    assert Video.is_valid?("demo/test.mp4") == true
  end

end
