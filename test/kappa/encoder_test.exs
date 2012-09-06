Code.require_file "../../test_helper", __FILE__

defmodule Kappa.TestEncoder do
  use ExUnit.Case, async: true

  test "encode" do
    assert 1 < byte_size(Kappa.Encoder.encode({200, [], ""}))
  end
end
