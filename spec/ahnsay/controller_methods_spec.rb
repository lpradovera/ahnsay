require 'spec_helper'

module Ahnsay
  describe ControllerMethods do
    describe "mixed in to a CallController" do

      class TestController < Adhearsion::CallController
        include Ahnsay::ControllerMethods
      end

      let(:mock_call) { mock 'Call' }
      let(:time) { Time.new(2012, 11, 10, 4, 15, 15) }
      let(:format) { 'dMY' }
      let(:number) { 42 }

      subject do
        TestController.new mock_call
      end

      before :each do
        Adhearsion.stub_chain("config.punchblock.platform").and_return(:foo)
        Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
      end

      describe "#sounds_for_time" do
        it "calls Ahnsay#sounds_for_time and returns the proper value" do
          subject.sounds_for_time(time, format: format).should == ["sounds/10.ul", "sounds/mon-10.ul", "sounds/20.ul", "sounds/12.ul"]
        end
      end

      describe "#sounds_for_number" do
        it "calls Ahnsay#sounds_for_number and returns the proper value" do
          subject.sounds_for_number(number).should == ["sounds/40.ul", "sounds/2.ul"]
        end
      end

      describe "#sounds_for_digits" do
        it "calls Ahnsay#sounds_for_digits and returns the proper value" do
          subject.sounds_for_digits(number).should == ["sounds/4.ul", "sounds/2.ul"]
        end
      end

    end
  end
end
