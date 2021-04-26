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

  # def to_pretty(s) do
  #   pretty = "%Metr.Modules.Deck{x: \"stuff\", y: {inner: \"other\"}}"
  #   |> format()

  #   IO.inspect s, label: "pretty"
  #   IO.inspect pretty, label: "pretty"

  #   pretty
  # end

  def to_pretty(s) when is_struct(s) do
    # pretty = s
    # |> Kernel.inspect()
    # |> String.replace("{", "{\n")
    # |> String.replace("[", "[\n")
    # |> String.replace(",", ",\n")

    IO.inspect s, label: "to pretty"
    # s = "%Metr.Modules.Deck{x: \"stuff\", y: {inner: \"other\"}}"

    s
    |> Kernel.inspect()
    |> pretty()
  end


  defp pretty(s) when is_bitstring(s) do
    IO.inspect s, label: "initializing"
    pretty(0, s)
  end

  defp pretty(_d, "") do
    ""
  end

  defp pretty(d, "{" <> rem) do
    dn = d + 1
    "{" <> "\n" <> tabs(dn) <> pretty(dn, String.trim(rem))
  end

  defp pretty(d, "}" <> rem) do
    dn = d - 1
    "\n" <> tabs(dn) <> "}" <> pretty(dn, String.trim(rem))
  end

  defp pretty(d, "[" <> rem) do
    dn = d + 1
    "[" <> "\n" <> tabs(dn) <> pretty(dn, String.trim(rem))
  end

  defp pretty(d, "]" <> rem) do
    dn = d - 1
    "\n" <> tabs(dn) <> "]" <> pretty(dn, String.trim(rem))
  end

  defp pretty(d, "," <> rem) do
    "," <> "\n" <> tabs(d) <> pretty(d, String.trim(rem))
  end

  defp pretty(d, s) do
    {c, rem} = String.split_at(s, 1)
    c <> pretty(d, rem)
  end

  defp tabs(n) do
    String.duplicate("\t", n)
  end


  # defp format({formated, "", _depth}) do
  #   formated
  # end

  # defp format({formated, reminder, depth}) do
  #   IO.inspect formated, label: "formated"
  #   IO.inspect reminder, label: "reminder"
  #   IO.inspect depth, label: "depth"
  #   formated <> (
  #     {reminder, depth}
  #     |> split()
  #     |> break()
  #     |> indent()
  #     |> build()
  #     |> format()
  #     )
  # end

  # defp format(s) do
  #   format({"", s, 0})
  # end


  # defp split({s, depth}) do
  #   {String.split(s, ~r{{}, parts: 2, include_captures: true), depth + 1}



  # end

  # defp break({[pre, split, rem], depth}) do
  #   {["#{pre}#{split}", "\n", rem], depth}
  # end
  # defp break({[rem], depth}) do
  #   {[rem], depth}
  # end

  # defp indent({[pre, break, rem], depth}) do
  #   tabs = String.duplicate("\t", depth)
  #   {[pre, break, tabs, rem], depth}
  # end
  # defp indent({[rem], depth}) do
  #   {[rem], depth}
  # end

  # defp build({[pre, break, ind, rem], depth}) do
  #   {"#{pre}#{break}#{ind}", rem, depth}
  # end
  # defp build({[rem], depth}) do
  #   {rem, "", depth}
  # end
end
