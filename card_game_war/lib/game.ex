defmodule CardGameWar.Game do

  # feel free to use these cards or use your own data structure"
  @suits [:spade, :club, :diamond, :heart]
  @ranks [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  @cards for suit <- @suits, rank <- @ranks, do: {suit, rank}

  defstruct deck_p1: [], deck_p2: []

  def cards, do: @cards

  def new do
    cards = @cards |> Enum.shuffle() |> Enum.shuffle() |> Enum.shuffle()
    {cards_p1, cards_p2} = Enum.split(cards, 26)
    %__MODULE__{deck_p1: cards_p1, deck_p2: cards_p2}
  end

  def play(%__MODULE__{deck_p1: []} = _game), do: :player_two
  def play(%__MODULE__{deck_p2: []} = _game), do: :player_one
  def play(%__MODULE__{deck_p1: [card_1 | other_cards_1 ], deck_p2: [card_2 | other_cards_2]} = game) do
    case round_winner(card_1, card_2) do
      :player_one ->
        play(%{game | deck_p1: other_cards_1 ++ [card_1, card_2], deck_p2: other_cards_2})
      :player_two ->
        play(%{game | deck_p1: other_cards_1, deck_p2: other_cards_2 ++ [card_1, card_2]})
      error -> throw error
    end
  end

  def round_winner({suit_1, rank_1}, {suit_2, rank_2})
  when
    suit_1 in @suits
    and suit_2 in @suits
    and rank_1 in @ranks
    and rank_2 in @ranks
  do
    rel_val_1 = Enum.find_index(@ranks, &(&1 == rank_1))
    rel_val_2 = Enum.find_index(@ranks, &(&1 == rank_2))

    cond do
      rel_val_1 > rel_val_2 -> :player_one
      rel_val_1 < rel_val_2 -> :player_two
      true ->
        suit_rel_val_1 = Enum.find_index(@suits, &(&1 == suit_1))
        suit_rel_val_2 = Enum.find_index(@suits, &(&1 == suit_2))

        cond do
          suit_rel_val_1 > suit_rel_val_2 -> :player_one
          suit_rel_val_1 < suit_rel_val_2 -> :player_two
          true -> {:error, "The 2 cards are the same! Come on!"}
        end
    end
  end
end
