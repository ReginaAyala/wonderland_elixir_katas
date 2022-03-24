defmodule Doublets.SolverTest do
  use ExUnit.Case
  import Doublets.Solver

  test "with word links found" do
    assert ["head", "heal", "teal", "tell", "tall", "tail"] ==
             doublets("head", "tail")

    assert ["door", "boor", "book", "look", "lock"] ==
             doublets("door", "lock")

    assert ["bank", "bonk", "book", "look", "loon", "loan"] ==
             doublets("bank", "loan")

    assert ["wheat", "cheat", "cheap", "cheep", "creep", "creed", "breed", "bread"] ==
             doublets("wheat", "bread")
  end

  test "with no word links found" do
    assert [] == doublets("ye", "freezer")
  end

  test "word same lenght" do
    assert ["muta", "task", "quat", "head", "heal", "teal", "tell", "tall", "tail", "door", "boor", "book", "look", "lock", "bonk", "loon", "loan"] == same_length_words("bank")
  end

  test "find variants" do
    assert ["heal"] == find_variants("head")
    assert ["heal", "tell"] == find_variants("teal")
  end

  test "last word" do
    assert "boor" == last_word(["bank", "bonk", "book", "boor"])
  end

  test "word difference" do
    assert 0 == distance("asdf", "asdfg")
    assert 1 == distance("door", "boor")
    assert 2 == distance("head", "teal")
    assert 3 == distance("head", "tell")
  end

  test "find solution" do
    assert ["bank", "bonk", "book"] == find_solution([["bank", "bonk", "book"]], "book")
    assert nil == find_solution([], "bank")
    assert nil == find_solution([["bank", "bonk", "book"]], "boor")
  end

  test "complete variants" do
    assert [["bank", "bonk", "book", "boor"], ["bank", "bonk", "book", "look"]] ==
             complete_seq_variants(["bank", "bonk", "book"])
  end
end
