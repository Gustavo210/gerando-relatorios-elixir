defmodule GenReport.HoursPerMonth do
  def call(list, acc), do: sum_hours_per_months(list, acc)

  # hours per month
  defp sum_hours_per_months(
         [user, hour, _day, month, _year],
         %{"hours_per_month" => hours_per_month}
       ) do
    user_per_month = hours_per_month[user]
    user_per_month = Map.put(user_per_month, month, user_per_month[month] + hour)
    hours_per_month = Map.put(hours_per_month, user, user_per_month)

    %{"hours_per_month" => hours_per_month}
  end
end
