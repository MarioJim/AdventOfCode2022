input = File.read!('./input.txt')

String.split(input, "\n")
    |> Enum.chunk_while(
        [],
        fn x, acc ->
          if byte_size(x) == 0 do
            {:cont, acc, []}
          else
            {:cont, [String.to_integer(x) | acc]}
          end
        end,
        fn acc -> {:cont, acc, []} end
      )
    |> Enum.map(&Enum.sum/1)
    |> Enum.max
    |> IO.puts
