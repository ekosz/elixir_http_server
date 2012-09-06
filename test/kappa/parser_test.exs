Code.require_file "../../test_helper", __FILE__

defmodule Kappa.ParserTest do
  use ExUnit.Case, async: true

  test "read the correct verb" do
    assert :get == Kappa.Parser.parse("GET /index.html HTTP/1.1").verb
  end

  test "read the correct uri" do
    assert "/" == Kappa.Parser.parse("GET / HTTP/1.1").uri.path
  end

  test "read the correct version" do
    assert "HTTP/1.1" == Kappa.Parser.parse("GET /index.html HTTP/1.1").version
  end

  test "creates the correct headers" do
    request = "GET / HTTP/1.1\r\nHost: google.com"
    assert "google.com" == Kappa.Parser.parse(request).headers[:host]
  end

  test "creates multiable headers" do
    request = "GET / HTTP/1.1\r\nHost: google.com\r\nContent-Length: 10"
    assert "google.com" == Kappa.Parser.parse(request).headers[:host]
    assert "10" == Kappa.Parser.parse(request).headers[:"content-length"]
  end

  test "creates the proper body" do
    request = "GET / HTTP/1.1\r\n\r\nBODY"
    assert "BODY" == Kappa.Parser.parse(request).body
  end

  test "full http request" do
    request = "GET /hi HTTP/1.1\nHost: localhost:3000\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.57 Safari/537.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Encoding: gzip,deflate,sdch\nAccept-Language: en-US,en;q=0.8\nAccept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3\n\n\n"

    assert :get == Kappa.Parser.parse(request).verb
  end

end
