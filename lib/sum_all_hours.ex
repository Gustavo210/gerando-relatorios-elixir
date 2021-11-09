defmodule GenReport.SumAllHours do
  def call(list, acc), do: sum_all_hours(list, acc)

  # all hours
  defp sum_all_hours([user, hour, _day, _month, _year], %{"all_hours" => users}) do
    users = Map.put(users, user, users[user] + hour)
    %{"all_hours" => users}
  end
end
