require 'spec_helper'

describe Ahnsay do
  subject { Ahnsay }

  describe "sounds_for_time" do
    before :each do
      Adhearsion.stub_chain("config.core.type").and_return(:foo)
      Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
    end
    let(:time) { Time.new(2012, 11, 10, 4, 15, 22) }
    it "calls the correct methods" do
      subject.should_receive(:parse_day).ordered.once.and_return([])
      subject.should_receive(:parse_month).ordered.once.and_return([])
      subject.should_receive(:parse_year).ordered.once.and_return([])
      subject.sounds_for_time(time, format: 'dMY')
    end

    it "returns the correct sounds for the default format" do
      subject.sounds_for_time(time).should == ["sounds/10.ul", "sounds/mon-10.ul", "sounds/20.ul", "sounds/12.ul", "sounds/at.ul", "sounds/4.ul", "sounds/15.ul"]
    end

    it "returns the correct sounds for a dMY format" do
      subject.sounds_for_time(time, format: 'dMY').should == ["sounds/10.ul", "sounds/mon-10.ul", "sounds/20.ul", "sounds/12.ul"]
    end
    it "returns the correct sounds for a hmp format" do
      subject.sounds_for_time(time, format: 'hmp').should == ["sounds/4.ul", "sounds/15.ul", "sounds/a-m.ul"]
    end
  end

  describe "sounds_for_digits" do
    before :each do
      Adhearsion.stub_chain("config.core.type").and_return(:foo)
      Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
    end
    let(:number) { "4041" }
    
    it "returns the single digits for the number" do
      subject.sounds_for_digits(number).should == ["sounds/4.ul", "sounds/0.ul", "sounds/4.ul", "sounds/1.ul"]
    end
  end
  
  context "TTS support methods" do
    before :each do
      Adhearsion.stub_chain("config.core.type").and_return(:foo)
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

    describe "#sounds_for_number" do
      it "returns the expected array for a number with thousands and tens above 20" do
        subject.sounds_for_number(2023).should == ["sounds/2.ul", "sounds/thousand.ul", "sounds/20.ul", "sounds/3.ul"]
      end
      it "returns the expected array for a number with thousands and tens below 20" do
        subject.sounds_for_number(2013).should == ["sounds/2.ul", "sounds/thousand.ul", "sounds/13.ul"]
      end
      it "returns the expected array for a number with hundreds" do
        subject.sounds_for_number(123).should == ["sounds/1.ul", "sounds/hundred.ul", "sounds/20.ul", "sounds/3.ul"]
      end
      it "returns the expected array for a number with tens above 20" do
        subject.sounds_for_number(23).should == ["sounds/20.ul", "sounds/3.ul"]
      end
      it "returns the expected array for a number with tens below 20" do
        subject.sounds_for_number(13).should == ["sounds/13.ul"]
      end
      it "returns the expected array for a number that is a multiple of 10" do
        subject.sounds_for_number(20).should == ["sounds/20.ul"]
      end
    end

    describe "#parse_hour_12h" do
      let(:am) { Time.new(2012, 11, 10, 4) }
      let(:pm) { Time.new(2012, 11, 10, 16) }
      let(:midnight) { Time.new(2012, 11, 10, 0) }

      it "returns the correct hour in 12hr format for an AM time" do
        subject.parse_hour_12h(am).should == ["sounds/4.ul"]
      end

      it "returns the correct hour in 12hr format for a PM time" do
        subject.parse_hour_12h(pm).should == ["sounds/4.ul"]
      end

      it "returns the correct hour in 12hr format for midnight" do
        subject.parse_hour_12h(midnight).should == ["sounds/12.ul"]
      end
    end

    describe "#parse_hour_24h" do
      let(:am) { Time.new(2012, 11, 10, 4) }
      let(:pm) { Time.new(2012, 11, 10, 16) }
      let(:midnight) { Time.new(2012, 11, 10, 0) }

      it "returns the correct hour in 24hr format for an AM time" do
        subject.parse_hour_24h(am).should == ["sounds/4.ul"]
      end

      it "returns the correct hour in 24hr format for a PM time" do
        subject.parse_hour_24h(pm).should == ["sounds/16.ul"]
      end

      it "returns the correct hour in 24hr format for midnight" do
        subject.parse_hour_24h(midnight).should == ["sounds/0.ul"]
      end
    end

    describe "#parse_minutes" do
      let(:time) { Time.new(2012, 11, 10, 4, 15) }
      let(:oclock) { Time.new(2012, 11, 10, 4, 0) }
      it "returns the correct files for the minute" do
        subject.parse_minutes(time).should == ["sounds/15.ul"]
      end
      
      it "returns o' clock when the minute is 0" do
        subject.parse_minutes(oclock).should == ["sounds/oclock.ul"]
      end
    end

    describe "#parse_seconds" do
      let(:time) { Time.new(2012, 11, 10, 4, 15, 15) }
      it "returns the correct files for the seconds" do
        subject.parse_seconds(time).should == ["sounds/15.ul"]
      end
    end

    describe "#parse_am_pm" do
      let(:am) { Time.new(2012, 11, 10, 4) }
      let(:pm) { Time.new(2012, 11, 10, 16) }
      it "returns the correct sound file for an AM time" do
        subject.parse_am_pm(am).should == ["sounds/a-m.ul"]
      end

      it "returns the correct sound file for a PM time" do
        subject.parse_am_pm(pm).should == ["sounds/p-m.ul"]
      end
    end

    describe "#parse_at" do
      let(:time) { Time.new(2012, 11, 10, 4, 15, 15) }
      it "returns the correct files for the at word" do
        subject.parse_at(time).should == ["sounds/at.ul"]
      end
    end

    describe "#parse_year" do
      let(:time) { Time.new(2012, 11, 10, 4, 15, 15) }
      it "returns the correct files for the year" do
        subject.parse_year(time).should == ["sounds/20.ul", "sounds/12.ul"]
      end
    end

    describe "#parse_month" do
      let(:time) { Time.new(2012, 11, 10, 4) }
      it "returns the correct file for the month" do
        subject.parse_month(time).should == ["sounds/mon-10.ul"]
      end
    end

    describe "#parse_day" do
      let(:time) { Time.new(2012, 11, 20, 4) }
      it "returns the correct file for the day" do
        subject.parse_day(time).should == ["sounds/20.ul"]
      end
    end

    describe "#parse_weekday" do
      let(:time) { Time.new(2012, 11, 11, 4) }
      it "returns the correct file for the day" do
        subject.parse_weekday(time).should == ["sounds/day-0.ul"]
      end
    end

  end

  context "path manipulation methods" do
    describe "#sound_path" do
      let(:sound_file) { "beep.ul" }
      it "returns the proper path" do
        Adhearsion.stub_chain("config.core.type").and_return(:foo)
        Adhearsion.stub_chain("config.ahnsay.sounds_dir").and_return("sounds")
        subject.sound_path(sound_file).should == File.join(Adhearsion.config.ahnsay.sounds_dir, sound_file)
      end
    end

    describe "#multi_path" do
      let(:path) { "/my/sounds/hello.wav" }
      before :each do
        Adhearsion.stub_chain("config.core.type").and_return(platform)
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
