module Ahnsay
    describe "config" do
      it "defaults to the plugin's sounds directory" do
        Adhearsion.config.ahnsay.sounds_dir.should == File.expand_path('../../../sounds', __FILE__) 
      end
    end
end
