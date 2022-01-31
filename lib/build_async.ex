defmodule GenReport.BuildAsync do
  def call(result, acc), do: sum_all(result, acc)

  defp sum_all(result, acc) do
    all_hours = merge_all(result["all_hours"], acc["all_hours"])
    hours_per_month = merge_all_maps(result["hours_per_month"], acc["hours_per_month"])
    hours_per_year = merge_all_maps(result["hours_per_year"], acc["hours_per_year"])

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp merge_all(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 ->
      value1 + value2
    end)
  end

  defp merge_all_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 ->
      merge_all(value1, value2)
    end)
  end
end
