defmodule HelpersTest do
  use ExUnit.Case

  alias Miew.Helpers

  test "text to bool" do
    assert true == Helpers.text_to_bool("true")
    assert false == Helpers.text_to_bool("false")

    assert true == Helpers.text_to_bool("1")
    assert false == Helpers.text_to_bool("0")

    assert false == Helpers.text_to_bool("")
    assert false == Helpers.text_to_bool(nil)
  end


  test "text to number" do
    assert 0 == Helpers.text_to_number(nil)
    assert 0 == Helpers.text_to_number("")
    assert 0 == Helpers.text_to_number("0")

    assert 1 == Helpers.text_to_number("1")
    assert -1 == Helpers.text_to_number("-1")
    assert 1.5 == Helpers.text_to_number("1.5")
    assert -1.5 == Helpers.text_to_number("-1.5")

    assert {:error, "x is not a number"} == Helpers.text_to_number("x")

    assert 1 == Helpers.text_to_number(1)
    assert -1 == Helpers.text_to_number(-1)
  end
end
