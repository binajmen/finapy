defmodule Finapy.Repo do
  use Ecto.Repo,
    otp_app: :Finapy,
    adapter: Ecto.Adapters.Postgres
end
