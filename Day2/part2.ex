input = File.read!('./input.txt')

String.split(input, "\n")
  |> Enum.map(fn line ->
    [<<p1>>, <<r>>] = String.split(line, " ")
    [p1, r] = [p1 - ?A, 3 * (r - ?X)]
    p2 = case r do
      0 -> rem(p1 + 2, 3)
      3 -> p1
      6 -> rem(p1 + 1, 3)
    end
    r + p2 + 1
  end)
  |> Enum.sum
  |> IO.puts
