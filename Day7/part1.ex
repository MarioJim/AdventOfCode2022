tree =
  File.read!('./input.txt')
  |> String.split("$ ")
  |> Enum.map(fn cmd ->
    cmd |> String.split("\n", trim: true) |> Enum.map(&String.split(&1, " "))
  end)
  |> Enum.drop(2)
  |> Enum.reduce({[], %{}}, fn
    [["cd", ".."]], {[_ | path], tree} ->
      {path, tree}

    [["cd", dir]], {path, tree} ->
      {[dir | path], tree}

    [["ls"] | output], {path, tree} ->
      {path,
       Enum.reduce(output, tree, fn
         ["dir", _], tree ->
           tree

         [file_size, file], tree ->
           keys =
             [file | path]
             |> Enum.reverse()
             |> Enum.map(&Access.key(&1, %{}))

           put_in(tree, keys, String.to_integer(file_size))
       end)}
  end)
  |> elem(1)

defmodule Tree do
  def calculate_size(node) when is_map(node) do
    Map.values(node)
    |> Enum.map(&calculate_size(&1))
    |> Enum.sum()
  end

  def calculate_size(node) when is_number(node) do
    node
  end

  def sum_nodes_with_at_most_100k_size(node) when is_map(node) do
    this_node_size = calculate_size(node)

    this_node =
      if is_map(node) && this_node_size < 100_000 do
        this_node_size
      else
        0
      end

    this_node +
      (Map.values(node)
       |> Enum.map(&sum_nodes_with_at_most_100k_size(&1))
       |> Enum.sum())
  end

  def sum_nodes_with_at_most_100k_size(node) when is_number(node) do
    0
  end
end

Tree.sum_nodes_with_at_most_100k_size(tree)
|> IO.inspect()
