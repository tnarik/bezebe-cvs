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

        it 'should be able to get information from two known files' do
            log = @client1.log "/tmp/w3c/test/", [ "/tmp/w3c/test/foo",
                 "/tmp/w3c/test/bar",
                 "/tmp/w3c/test/blah" ]

            puts log.logInfo.to_yaml unless log.nil?
        end

        it 'should be able to get information from a known file' do
            log = @client1.log "/tmp/w3c/test/", "/tmp/w3c/test/foo"

            puts log.logInfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts log.logInfo.revisions.to_yaml
            unless log.logInfo.symbolicNames.nil? or log.logInfo.symbolicNames.empty? then
                puts "\nInformation from symbolic names\n"
                names = log.logInfo.symbolicNames 
                names.each do |k, name|
                    puts "- NAME: #{name.name}       FOR REVISION: #{name.revision}     BRANCH?: #{name.isBranch?}"
                end
                puts "\n\n"
            end
        end

    end

end