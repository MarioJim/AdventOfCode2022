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

  def calculate_all_dir_sizes(node, path) when is_map(node) do
    this_node = {path, calculate_size(node)}

    child_nodes =
      Enum.flat_map(node, fn {child_name, child_node} ->
        calculate_all_dir_sizes(child_node, path <> "/" <> child_name)
      end)

    [this_node | child_nodes]
  end

  def calculate_all_dir_sizes(node, _) when is_number(node) do
    []
  end
end

min_space_needed = Tree.calculate_size(tree) + 30_000_000 - 70_000_000

Tree.calculate_all_dir_sizes(tree, "")
|> Enum.sort_by(&elem(&1, 1))
|> Enum.drop_while(&(elem(&1, 1) < min_space_needed))
|> List.first()
|> IO.inspect()
