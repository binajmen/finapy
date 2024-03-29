defmodule Finapy.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Finapy.Auth` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email"
      })
      |> Finapy.Auth.create_user()

    user
  end
end
