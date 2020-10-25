defmodule Miew.Helpers do

  def text_to_bool(nil), do: false
  def text_to_bool(term) when is_bitstring(term) do
    case term do
      "true" -> true
      "false" -> false
    end
  end
end
