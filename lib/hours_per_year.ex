defmodule GenReport.HoursPerYear do
  def call(list, acc), do: sum_hours_per_year(list, acc)

  # hours per years
  defp sum_hours_per_year(
         [user, hour, _day, _month, year],
         %{"hours_per_year" => hours_per_year}
       ) do
    user_per_year = hours_per_year[user]
    user_per_year = Map.put(user_per_year, year, user_per_year[year] + hour)
    hours_per_year = Map.put(hours_per_year, user, user_per_year)
    %{"hours_per_year" => hours_per_year}
  end
end
