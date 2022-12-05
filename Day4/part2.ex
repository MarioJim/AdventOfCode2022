input = File.read!('./input.txt')

String.split(input, "\n")
  |> Enum.map(fn line ->
    [eA0, eA1, eB0, eB1] = line
      |> String.split(["-", ","])
      |> Enum.map(&String.to_integer/1)

    if (eA0 <= eB1 && eA1 >= eB0) || (eB0 <= eA1 && eB1 >= eA0) do
      1
    else
      0
    end
  end)
  |> Enum.sum
  |> IO.puts
