input = File.read!('./input.txt')
lines = String.split(input, "\n")

stacks =
  lines
  |> Enum.take(8)
  |> Enum.map(
    &(String.to_charlist(&1)
      |> Enum.drop(1)
      |> Enum.take_every(4))
  )
  |> Enum.reduce(%{}, fn row, stacks ->
    row
    |> Enum.zip(1..9)
    |> Enum.reduce(stacks, fn
      {?\s, _}, stacks ->
        stacks

      {crate, idx}, stacks ->
        Map.update(
          stacks,
          idx,
          [crate],
          &[crate | &1]
        )
    end)
  end)
  |> IO.inspect()

lines
|> Enum.drop(10)
|> Enum.reduce(stacks, fn row, stacks ->
  [times, stackFrom, stackTo] =
    row
    |> String.split(" ")
    |> Enum.drop(1)
    |> Enum.take_every(2)
    |> Enum.map(&String.to_integer/1)

  {newStackFrom, crates} =
    stacks
    |> Map.fetch!(stackFrom)
    |> Enum.split(-times)

  stacks
  |> Map.put(stackFrom, newStackFrom)
  |> Map.update!(stackTo, &(&1 ++ Enum.reverse(crates)))
end)
|> IO.inspect()
|> Map.values()
|> Enum.map(&List.last(&1))
|> IO.inspect()
