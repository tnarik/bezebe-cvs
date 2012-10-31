describe Bezebe::CVS do
    describe "when using a known repository (W3)" do

        describe "with correct credentials" do
            it "should work"
        end

        describe "with wrong credentials" do
            it "shouldn't work"
        end
        
        before do
            #::Bezebe::CVS.stub!(:puts)
            #::Bezebe::CVS.stub!(:p)
            #stub!(:puts)
            #stub!(:p)
            @client1 = ::Bezebe::CVS::CVSClient.new
            @client1.connect FactoryGirl.attributes_for(:connection_details)
        end

        it 'should be able to get information from a known file' do
            status = @client1.update "/tmp/w3c/test/foo"
            puts status.logInfo.to_yaml unless status.nil?
        end

        it 'should be able to get information from two known files' do
            status = @client1.update [ "/tmp/w3c/test/foo", "/tmp/w3c/test/bar" ]
            puts status.logInfo.to_yaml unless status.nil?
        end

    end

end