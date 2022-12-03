input = File.read!('./input.txt')

String.split(input, "\n")
  |> Enum.chunk_every(3)
  |> Enum.map(fn lines ->
    [l1, l2, l3] = Enum.map(lines, fn x -> MapSet.new(to_charlist(x)) end)
    inters = MapSet.intersection(l1, MapSet.intersection(l2, l3))
    [dif] = MapSet.to_list(inters)
    if dif <= ?Z do
      dif - ?A + 27
    else
      dif - ?a + 1
    end
  end)
  |> Enum.sum
  |> IO.puts
