defmodule FoxGooseBagOfCorn.Puzzle do

  @start_position [
    [[:fox, :goose, :corn, :you], [:boat], []]
  ]
  @bad_position [
    [:fox, :goose],
    [:goose, :fox],
    [:corn, :goose],
    [:goose, :corn],
    [:fox, :goose, :corn],
    [:fox, :corn, :goose],
    [:goose, :fox, :corn],
    [:goose, :corn, :fox],
    [:corn, :fox, :goose],
    [:corn, :goose, :fox]
  ]

  def move([a, b, c], from: :left, to: :center) do
    Enum.map(a, fn x -> 
    [a -- [:you, x], b ++ [:you, x], c]
    end)
    |> Enum.map(fn x -> Enum.map(x, fn e -> Enum.uniq(e) end) end)
  end 

  def move([a, b, c], from: :center, to: :right) do 
    Enum.map(b -- [:boat], fn x ->
      [a, b -- [:you, x], c ++ [:you, x]]
    end)
    |> Enum.map(fn x -> Enum.map(x, fn e -> Enum.uniq(e) end) end)
  end

  def move([a, b, c], from: :right, to: :center) do
    Enum.map(c, fn x -> 
      [a, b ++ [:you, x], c -- [:you, x]]
    end)
    |> Enum.map(fn x -> Enum.map(x, fn e -> Enum.uniq(e) end) end)
  end

  def move([a, b, c], from: :center, to: :left) do
    Enum.map(b -- [:boat], fn x ->
      [a ++ [:you, x], b -- [:you, x], c]
    end)
    |> Enum.map(fn x -> Enum.map(x, fn e -> Enum.uniq(e) end) end)
  end
  
  def exceptions([a, b, c]) do
    not Enum.member?(@bad_position, a) and
    not Enum.member?(@bad_position, b) and
    not Enum.member?(@bad_position, c) and 
    (length(b) <= 3)
  end 

  def next_position(from: l, to: r) do
    case {l, r} do
      {:left, :center} -> {:center, :right} 
      {:center, :right} -> {:right, :center}
      {:right, :center} -> {:center, :left}
      {:center, :left} -> {:left, :center}
    end
  end

  def next_move([[a, b, c] | ls] = plan, from: l, to: r) do
    x =
      move([a, b, c], from: l, to: r)
      |> IO.inspect()
      |> Enum.filter(&exceptions/1)
      |> Enum.filter(fn z -> z not in plan end)

    if length(x) != 0 do
      x |> Enum.flat_map(fn f -> 
            {n_from, n_to} = next_position(from: l, to: r)
            next_move([f | plan], from: n_from, to: n_to)
           end)
    else 
      [plan]
    end
  end

  def river_crossing_plan do
    next_move(@start_position, from: :left, to: :center)
    |> List.last()
    |> Enum.reverse()
  end
end