defmodule Kappa.Encoder do
  def encode(res) do
    {code, heads, body} = res
    status_line(code) <> headers(heads, body) <> "\r\n" <> body
  end

  defp status_line(code) do
    "HTTP/1.1 #{code} OK\r\n"
  end

  defp headers(heads, body) do
    Enum.reduce extra_headers(heads, body), "", fn(x, acc) ->
      acc <> "#{elem(x, 1)}: #{elem(x, 2)}\r\n"
    end
  end

  defp extra_headers(heads, body) do
    add_content_length(add_date(heads), body)
  end

  defp add_date(heads) do
    Keyword.put(heads, :Date, date())
  end

  defp date() do
    :httpd_util.rfc1123_date(:erlang.universaltime())
  end

  defp add_content_length(heads, body) do
    Keyword.put heads, :"Content-Length", byte_size(body)
  end

end
