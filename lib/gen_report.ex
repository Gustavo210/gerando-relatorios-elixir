defmodule GenReport do
  alias GenReport.HoursPerMonth
  alias GenReport.HoursPerYear
  alias GenReport.Parser
  alias GenReport.SumAllHours

  @users [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]
  defp getRaw(filename) do
    filename
    |> Parser.parse_file()
  end

  def build(filename) when is_binary(filename) do
    raw = getRaw(filename)
    %{"all_hours" => all_hours} = Enum.reduce(raw, report_users_acc(), &SumAllHours.call/2)

    %{"hours_per_month" => hours_per_month} =
      Enum.reduce(raw, report_users_acc(), &HoursPerMonth.call/2)

    %{"hours_per_year" => hours_per_year} =
      Enum.reduce(raw, report_users_acc(), &HoursPerYear.call/2)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of strings"}
  end

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build(&1))
    |> Enum.reduce(report_users_acc(), fn {:ok, list}, acc -> sum_all(list, acc) end)
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp sum_all(result, acc) do
    all_hours = merge_user_all_hours(result["all_hours"], acc["all_hours"])

    %{
      "all_hours" => all_hours
    }
  end

  defp merge_user_all_hours(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 ->
      value1 + value2
    end)
  end

  defp report_users_acc do
    users = Enum.into(@users, %{}, &{String.downcase(&1), 0})
    months = Enum.into(@months, %{}, &{&1, 0})
    years = Enum.into(2016..2020, %{}, &{&1, 0})
    hours_per_year = Enum.into(@users, %{}, &{&1, years})
    hours_per_month = Enum.into(@users, %{}, &{&1, months})

    %{
      "all_hours" => users,
      "months" => months,
      "hours_per_year" => hours_per_year,
      "hours_per_month" => hours_per_month
    }
  end
end
