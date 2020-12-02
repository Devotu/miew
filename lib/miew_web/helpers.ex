defmodule Miew.Helpers do

  def text_to_bool(nil), do: false
  def text_to_bool(""), do: false
  def text_to_bool("true"), do: true
  def text_to_bool("false"), do: false
  def text_to_bool("1"), do: true
  def text_to_bool("0"), do: false

  def text_to_number(nil), do: 0
  def text_to_number(""), do: 0
  def text_to_number(term) when is_number(term), do: term
  def text_to_number(term) do
    case Float.parse(term) do
      {x, ""} -> x
      :error -> {:error, "#{term} is not a number"}
    end
  end

  def text_to_integer(nil), do: 0
  def text_to_integer(""), do: 0
  def text_to_integer(term) when is_number(term), do: term
  def text_to_integer(term) do
    case Integer.parse(term) do
      {x, ""} -> x
      :error -> {:error, "#{term} is not a number"}
    end
  end
end
