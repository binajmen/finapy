defmodule FinapyWeb.Plugs.Ory do
  import Plug.Conn

  alias Finch.Response

  def init(opts), do: opts

  def call(conn, _opts) do
    url = "http://localhost:3001/sessions/whoami"

    modified_headers =
      Enum.filter(conn.req_headers, fn {key, _} -> key != "accept" end) ++
        [{"accept", "application/json"}]

    case Finch.build(:get, url, modified_headers) |> Finch.request(Finapy.Finch) do
      {:ok, %Response{status: 200, body: body}} ->
        session = :zlib.gunzip(body) |> Jason.decode!()
        assign(conn, :user_id, session["identity"]["id"])

      {:ok, %Response{status: status}} ->
        IO.inspect({:error, "Request failed with status: #{status}"})
        halt(conn)

      {:error, reason} ->
        IO.inspect({:error, reason})
        halt(conn)
    end
  end
end
