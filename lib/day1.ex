defmodule Day1 do
  def solution do
    load_data
    |> parse
    |> schedule_calculators

    await_response()
  end

  defp load_data do
    :code.priv_dir(:day1)
    |> to_string
    |> Kernel.<>("/data")
    |> File.read!()
  end

  defp parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp schedule_calculators([_last_number]), do: nil

  defp schedule_calculators([head | remaining]) do
    pid = self()

    spawn(fn ->
      case remaining
           |> Enum.find(:not_found, &matches_expected_product(head, &1)) do
        :not_found -> :ok_gonna_die_now
        match -> send(pid, {:response, head, match})
      end
    end)

    schedule_calculators(remaining)
  end

  defp await_response do
    receive do
      {:response, first, second} ->
        IO.puts("The numbers #{first} and #{second} add up to #{first + second}.")
        IO.puts("Their product is #{first * second}")
    end
  end

  defp matches_expected_product(first, second) do
    first + second == 2020
  end
end
