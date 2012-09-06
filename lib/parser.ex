defmodule Kappa.Parser do

  defrecord Request, verb: nil, uri: nil, version: nil, headers: nil, body: nil

  def parse(request) do
    lines = split_into_lines(request)
    [first_line | rest] = lines

    {verb, uri, version} = parse_initial_request_line(first_line)

    {headers, body} = parse_headers_and_body(rest)

    Request.new(verb: verb, uri: uri, version: version,
                headers: headers, body: body)
  end

  # Split on new lines
  defp split_into_lines(string) do
    Regex.split(%r/(?:\r)?\n/, string)
  end

  defp parse_initial_request_line(line) do
    [verb, path, version | _] = Regex.split(%r/ /, line)

    {to_lower_case_atom(verb), URI.parse(to_binary(path)), version}
  end

  defp parse_headers_and_body(lines) do
    not_blank_line = fn(line) -> !Regex.match?(%r/^\s*$/, line) end

    headers = parse_headers(Enum.take_while(lines, not_blank_line))

    body = Enum.reduce Enum.drop_while(lines, not_blank_line), "", fn(x, acc) -> 
      acc <> "\n" <> x
    end

    {headers, substring(body, 2)}
  end

  defp parse_headers(headers) do
    Enum.reduce headers, [], fn(x, acc) ->
      [type | [value | _]] = Regex.split(%r/: /, x, 2)
      Keyword.put acc, to_lower_case_atom(type), value
    end
  end

  defp to_lower_case_atom(list) when is_list(list) do
    to_lower_case_atom(list_to_binary(list))
  end

  defp to_lower_case_atom(string) when is_binary(string) do
    list_to_atom(:string.to_lower(binary_to_list(string)))
  end

  defp substring(string, ammount) when is_binary(string) and ammount >= byte_size(string) do
    string
  end

  defp substring(string, ammount) when is_binary(string) do
    :binary.part string, ammount, byte_size(string)-ammount
  end
end
