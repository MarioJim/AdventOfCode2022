input = File.read!('./input.txt')

String.split(input, "\n")
  |> Enum.map(fn line ->
    [<<p1>>, <<p2>>] = String.split(line, " ")
    [p1, p2] = [p1 - ?A, p2 - ?X]
    r = cond do
      p1 == p2 -> 3 # Tie
      rem(p2 + 1, 3) == p1 -> 0 # I lost
      true -> 6 # I won
    end
    r + p2 + 1
  end)
  |> Enum.sum
  |> IO.puts
