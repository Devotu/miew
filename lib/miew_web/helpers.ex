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

  def to_pretty(s) when is_struct(s) do
    Kernel.inspect(s) |> pretty()
  end

  def to_pretty(s) do
    IO.inspect Kernel.inspect(s), label: "Helpers - pretty"
  end

  defp pretty(s) when is_bitstring(s) do
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

  defp pretty(d, "[]" <> rem) do
    "[]" <> pretty(d, String.trim(rem))
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

  def as_percent(0), do: 0
  def as_percent(n) when is_number(n) and n > 0 and n < 1 do
    Float.round(n * 100, 2)
  end
  def as_percent(n) when is_number(n) and n > 0 and n < 100 do
    Float.round(n, 2)
  end
  def as_percent(n) do
    "#{n} not %"
  end
end
