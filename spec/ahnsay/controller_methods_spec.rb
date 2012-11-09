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

      describe "#sound_path" do
        let(:sound_file) { "beep.ul" }
        it "returns the proper path" do
          Adhearsion.stub_chain("config.punchblock.platform").and_return(:foo)
          Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
          subject.sound_path(sound_file).should == File.join(Adhearsion.config.ahnsay.sounds_dir, sound_file)
        end
      end
    end
  end
end
