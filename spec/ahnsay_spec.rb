require 'spec_helper'

describe Ahnsay do
  subject { Ahnsay }
  
  context "TTS support methods" do
    before :each do
      Adhearsion.stub_chain("config.punchblock.platform").and_return(:foo)
      Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
    end
    describe "#file_for_day" do
      it "returns the correct audio file name for the day" do
        subject.file_for_day(4).should == "sounds/day-4.ul"
      end 
    end

    describe "#file_for_month" do
      it "returns the correct audio file name for the day" do
        subject.file_for_month(4).should == "sounds/mon-3.ul"
      end 
    end

    describe "#files_for_number" do
      it "returns the expected array for a number with thousands and tens above 20" do
        subject.files_for_number(2023).should == ["sounds/2.ul", "sounds/thousand.ul", "sounds/20.ul", "sounds/3.ul"]
      end
      it "returns the expected array for a number with thousands and tens below 20" do
        subject.files_for_number(2013).should == ["sounds/2.ul", "sounds/thousand.ul", "sounds/13.ul"]
      end
      it "returns the expected array for a number with hundreds" do
        subject.files_for_number(123).should == ["sounds/1.ul", "sounds/hundred.ul", "sounds/20.ul", "sounds/3.ul"]
      end
      it "returns the expected array for a number with tens above 20" do
        subject.files_for_number(23).should == ["sounds/20.ul", "sounds/3.ul"]
      end
      it "returns the expected array for a number with tens below 20" do
        subject.files_for_number(13).should == ["sounds/13.ul"]
      end
    end
  end

  context "path manipulation methods" do
    describe "#sound_path" do
      let(:sound_file) { "beep.ul" }
      it "returns the proper path" do
        Adhearsion.stub_chain("config.punchblock.platform").and_return(:foo)
        Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
        subject.sound_path(sound_file).should == File.join(Adhearsion.config.ahnsay.sounds_dir, sound_file)
      end
    end

    describe "#multi_path" do
      let(:path) { "/my/sounds/hello.wav" }
      before :each do
        Adhearsion.stub_chain("config.punchblock.platform").and_return(platform)
      end
      context "on Asterisk" do
        let(:platform) { :asterisk }
        it "returns the correct path with no extension and no scheme" do
          subject.multi_path(path).should == "/my/sounds/hello"
        end
      end

      context "on XMPP" do
        let(:platform) { :xmpp }
        it "returns the correct path with extension and scheme" do
          subject.multi_path(path).should == "file:///my/sounds/hello.wav"
        end
      end

      context "on FreeSWITCH" do
        let(:platform) { :freeswitch }
        it "returns the correct path with extensiona and without scheme" do
          subject.multi_path(path).should == "/my/sounds/hello.wav"
        end
      end
    end
  end
end
