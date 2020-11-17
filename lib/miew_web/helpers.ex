defmodule Miew.Helpers do

  def text_to_bool(nil), do: false
  def text_to_bool(""), do: false
  def text_to_bool("true"), do: true
  def text_to_bool("false"), do: false
  def text_to_bool("1"), do: true
  def text_to_bool("0"), do: false
end
