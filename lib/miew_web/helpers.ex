defmodule Miew.Helpers do
  alias Phoenix.LiveView

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

  def to_pretty(s) do
    pretty = "%Metr.Modules.Deck{x: \"stuff\", y: {inner: \"other\"}}"
    |> format()

    IO.inspect s, label: "pretty"
    IO.inspect pretty, label: "pretty"

    pretty
  end

  def to_pretty(s) when is_struct(s) do
    pretty = s
    |> Kernel.inspect()
    |> String.replace("{", "{\n")
    |> String.replace("[", "[\n")
    |> String.replace(",", ",\n")

    IO.inspect pretty, label: "pretty"

    pretty
  end


  defp format({formated, ""}) do
    formated
  end

  defp format({formated, reminder}) do
    IO.inspect formated, label: "formated"
    IO.inspect reminder, label: "reminder"
    reminder
    |> split()
    |> break()
    |> indent()
    |> build()
    |> format()
  end

  defp format(s) do
    format({"", s})
  end


  defp split(s) do
    String.split(s, ~r{{}, parts: 2, include_captures: true)
  end

  defp break([pre, split, rem]) do
    ["#{pre}#{split}", "\n", rem]
  end
  defp break([rem]) do
    [rem]
  end

  defp indent([pre, break, rem]) do
    [pre, break, "\t", rem]
  end
  defp indent([rem]) do
    [rem]
  end

  defp build([pre, break, ind, rem]) do
    {"#{pre}#{break}#{ind}", rem}
  end
  defp build([rem]) do
    {rem, ""}
  end
end
