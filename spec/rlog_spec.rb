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
            stub!(:puts)
            #stub!(:p)
            @client1 = ::Bezebe::CVS::CVSClient.new
            @client1.connect FactoryGirl.attributes_for(:connection_details)
        end

        it 'should be able to get information from a known file' do
            rlog = @client1.rlog "w3c/test/foo"

            puts rlog.logInfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts rlog.logInfo.revisions.to_yaml
            unless rlog.logInfo.symbolicNames.nil? or rlog.logInfo.symbolicNames.empty? then
                puts "\nInformation from symbolic names\n"
                names = rlog.logInfo.symbolicNames 
                names.each do |k, name|
                    puts "- NAME: #{name.name}       FOR REVISION: #{name.revision}     BRANCH?: #{name.isBranch?}"
                end
                puts "\n\n"
            end
        end

        it 'should be able to get information from two files' do
            a = [ "w3c/test/foo", "w3c/test/bar" ]
            rlog = @client1.rlog a

            puts rlog.logInfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts rlog.logInfo.revisions.to_yaml
            unless rlog.logInfo.symbolicNames.nil? or rlog.logInfo.symbolicNames.empty? then
                puts "\nInformation from symbolic names\n"
                names = rlog.logInfo.symbolicNames 
                names.each do |k, name|
                    puts "- NAME: #{name.name}       FOR REVISION: #{name.revision}     BRANCH?: #{name.isBranch?}"
                end
                puts "\n\n"
            end
        end

        it 'should be able to get information from a known folder' do
            rlog = @client1.rlog "w3c/test"

            puts rlog.logInfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts rlog.logInfo.revisions.to_yaml
            unless rlog.logInfo.symbolicNames.nil? or rlog.logInfo.symbolicNames.empty? then
                puts "\nInformation from symbolic names\n"
                names = rlog.logInfo.symbolicNames 
                names.each do |k, name|
                    puts "- NAME: #{name.name}       FOR REVISION: #{name.revision}     BRANCH?: #{name.isBranch?}"
                end
                puts "\n\n"
            end
        end

        it 'should be able to get information from two known folders' do
            rlog = @client1.rlog [ "w3c/test", "issues" ]

            puts rlog.logInfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts rlog.logInfo.revisions.to_yaml
            unless rlog.logInfo.symbolicNames.nil? or rlog.logInfo.symbolicNames.empty? then
                puts "\nInformation from symbolic names\n"
                names = rlog.logInfo.symbolicNames 
                names.each do |k, name|
                    puts "- NAME: #{name.name}       FOR REVISION: #{name.revision}     BRANCH?: #{name.isBranch?}"
                end
                puts "\n\n"
            end
        end

        it 'should not be able to get information from an unknown file' do
            @client1.rlog "w3c/test/this_doesnt_exist"
        end
    end

    it 'should not connect if credentials are wrong'

    it 'should be able to perform a rlog'

    describe "when using rlog" do
        it "should do something else"
    end


    describe "with proper credentials" do
        it "should work"

        it "should fail"
    end

end