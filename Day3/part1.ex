input = File.read!('./input.txt')

String.split(input, "\n")
  |> Enum.map(fn line ->
    {c1, c2} = String.split_at(line, div(byte_size(line), 2))
    [c1, c2] = [MapSet.new(to_charlist(c1)), MapSet.new(to_charlist(c2))]
    [dif] = MapSet.to_list(MapSet.intersection(c1, c2))
    if dif <= ?Z do
      dif - ?A + 27
    else
      dif - ?a + 1
    end
  end)
  |> Enum.sum
  |> IO.puts
