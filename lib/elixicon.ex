defmodule Elixicon do


  @moduledoc """
  Elixicon -
  This project creates Indenticons with elixir.

  what is an Identicon?
  an Identicon is a visual representation of a hash value, usually of an id   number, that serves to identify a user of a computer system as a form of    an avatar while protecting the user’s privacy.
  """

  @doc """
  Takes user input and passes it through the hash,color, grid and image functions
  ## Example

        iex> Elixicon.main("jpp")
        [
          [57, 227, 14],
          [172, 70, 250],
          [241, 254, 220],
          [191, 221, 39],
          [158, 166, 210]
        ]
        iex>
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image

  end

  def draw_image(%Elixicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)
    Enum.each pixel_map, fn({start,stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
      end
    :egd.render(image)
  end


  def build_pixel_map(%Elixicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index,5) * 50
      verticle = div(index, 5) * 50
      top_left = {horizontal, verticle}
      bottom_right = {horizontal+ 50, verticle + 50}
      {top_left, bottom_right}
    end
  end

  def filter_odd_squares(%Elixicon.Image{grid: grid} = image) do
    grid=Enum.filter grid, fn({code,_index}) ->
      rem(code,2) == 0
    end
    %Elixicon.Image{image | grid: grid}
  end


  def build_grid(%Elixicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Elixicon.Image{image | grid: grid}
  end

  @doc """
   Appends first two elements of row to the end of the row

  ## Example

        iex> Elixicon.main("jpp")
        [
          [57, 227, 14, 227, 15],
          [172, 70, 250, 70, 172],
          [241, 254, 220, 254, 241],
          [191, 221, 39, 221, 191],
          [158, 166, 210, 166, 158]
        ]
        iex>
  """
  def mirror_row(row) do
    [first, second | _tail] = row # [x, y, z,]
    row ++ [second, first] # [x, y, z, y, x] append
  end

  def pick_color(%Elixicon.Image{hex: [r,g,b | _tail]} = image) do
    %Elixicon.Image{image | color: {r,g,b}}
  end

  def hash_input(input) do
    hex =  :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    %Elixicon.Image{hex: hex}
  end

end
