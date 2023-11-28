defmodule Elixicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_elixicon
    |> save_elixicon(input)
  end

  def save_elixicon(image,  input) do
  
    File.write("#{input}", image)
  end

 def draw_elixicon(%Elixicon.Image{color: color, pixel_map: pixel_map}) do 
    
    image = :egd.create(250, 250)
    fill = :egd.color(color)
    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill) 
    end
    :egd.render(image) 
  end

  def build_pixel_map(%Elixicon.Image{grid: grid} = image) do
    
    pixel_map = Enum.map grid, fn({_code, index}) -> 
      horizontal = rem(index, 5) * 50
      verticle = div(index, 5) * 50  
      top_left = {horizontal, verticle}
      bottom_right = {horizontal+ 50, verticle + 50}
      {top_left, bottom_right}
    end
    %Elixicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Elixicon.Image{grid: grid} = image) do
    
    grid = Enum.filter grid, fn({code,_index}) ->
      rem(code,2) == 0
    end
    %Elixicon.Image{image | grid: grid}
  end


  def build_grid(%Elixicon.Image{hex: hex} = image) do
    
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Elixicon.Image{image | grid: grid}
  end

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
