defmodule AlphabetCipher.Coder do

  def encode(clave, texto) do

    clave = clave |> String.duplicate(ceil(String.length(texto) / String.length(clave)))
    texto = texto |> to_charlist() |> Enum.map(& &1)
    clave = clave |> to_charlist()

    abecedario = Enum.map(?a..?z, & &1)
    abecedario = abecedario |> Enum.with_index()

    fila = clave |> Enum.map(fn x -> List.keyfind(abecedario, x, 0) end) |> Enum.map(fn {_k, v} -> v end)
    columna = texto |> Enum.map(fn x -> List.keyfind(abecedario, x, 0) end) |> Enum.map(fn {_k, v} -> v end)

    matriz = List.zip([columna, fila])

    a = Enum.map(columna, fn x -> Enum.slice(97..122, x..25) ++ Enum.slice(97..122, 0..(x - 1)) end)
    b = matriz |> Enum.map(fn {_k, v} -> v end)
    c = Enum.zip(a, b)

    codificado = c |> Enum.map(fn {x, y} -> Enum.at(x, y) end) |> to_string

  end

  def decode(clave, codificado) do

    clave = clave |> String.duplicate(ceil(String.length(codificado) / String.length(clave)))
    codificado = codificado |> to_charlist() |> Enum.map(& &1)
    clave = clave |> to_charlist()

    abecedario = Enum.map(?a..?z, & &1)
    abecedario = abecedario |> Enum.with_index()

    fila =
      clave
      |> Enum.map(fn x -> List.keyfind(abecedario, x, 0) end)
      |> Enum.map(fn {_k, v} -> v end)

    a = Enum.map(fila, fn x -> Enum.slice(97..122, x..25) ++ Enum.slice(97..122, 0..(x - 1)) end)
    b = Enum.zip(a, codificado)
    c = Enum.map(b, fn {k, v} -> Enum.find_index(k, fn x -> x == v end) end)

    mensaje =
      Enum.map(c, fn x -> Enum.at(abecedario, x) end)
      |> Enum.map(fn {k, _v} -> k end)
      |> to_string

  end

  def decipher(codificado, mensaje) do

    codificado = codificado |> to_charlist 
    mensaje = mensaje |> to_charlist

    abecedario = Enum.map(?a..?z, & &1)
    abecedario = abecedario |> Enum.with_index()

    fila = mensaje |> Enum.map(fn x -> List.keyfind(abecedario, x, 0) end) |> Enum.map(fn {_k, v} -> v end)

    a = Enum.map(fila, fn x -> Enum.slice(97..122, x..25) ++ Enum.slice(97..122, 0..(x - 1)) end)
    b = Enum.zip(a, codificado)
    c = Enum.map(b, fn {k, v} -> Enum.find_index(k, fn x -> x == v end) end)
    codificado = codificado |> to_string
    mensaje = mensaje |> to_string

    clave =
      Enum.map(c, fn x -> Enum.at(abecedario, x) end) |> Enum.map(fn {k, _v} -> k end) 
      Enum.reduce(clave, "", fn x, acc -> 
        cond do 
          String.length(acc) == 0 -> acc <> to_string([x])
          encode(acc, mensaje) == codificado -> acc
          true -> acc <> to_string([x])
        end    
      end)
      
  end
end
