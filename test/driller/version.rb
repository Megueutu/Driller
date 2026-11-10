# frozen_string_literal: true

require "helper"

class VersionTest < Minitest::Test
  def test_tem_versao
    refute_nil Driller::VERSION
  end
end
