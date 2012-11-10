require 'spec_helper'

module Ahnsay
  describe ControllerMethods do
    describe "mixed in to a CallController" do

      class TestController < Adhearsion::CallController
        include Ahnsay::ControllerMethods
      end

      let(:mock_call) { mock 'Call' }

      subject do
        TestController.new mock_call
      end

    end
  end
end
