class PrawnsController < ApplicationController
  def test
    prawnto :inline => true
  end
end
