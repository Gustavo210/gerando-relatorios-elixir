defmodule GenReportTest do
  use ExUnit.Case

  alias GenReport
  alias GenReport.Support.ReportFixture

  @file_name "gen_report.csv"

  describe "build/1" do
    test "When passing file name return a report" do
      response = GenReport.build(@file_name)

      assert response == ReportFixture.build()
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build()

      assert response == {:error, "Enter a file name"}
    end
  end

  describe "build_from_many/1" do
    test "When passing file name return a report" do
      response = GenReport.build_from_many(["part_1.csv", "part_2.csv", "part_3.csv"])

      assert response == ReportFixture.build()
    end

    test "When no list of filename was given, returns an error" do
      response = GenReport.build_from_many("")

      assert response == {:error, "Please provide a list of strings"}
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build_from_many()

      assert response == {:error, "Enter a file name"}
    end
  end
end
