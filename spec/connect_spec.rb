describe Bezebe::CVS::CVSClient do

    it { should respond_to(:connect) }

    describe "#connect" do

        before :each do
            #::Bezebe::CVS.stub!(:puts)
            #::Bezebe::CVS.stub!(:p)
            #stub!(:puts)
            #stub!(:p)

            @connection_details = { username: "anonymous",
                password: "anonymous",
                host: "dev.w3.org",
                repository: "/sources/public" }
        end

        context "regarding parameters" do
            it "supports a hash" do
                client = ::Bezebe::CVS::CVSClient.new
                expect { client.connect @connection_details }.to_not raise_error (ArgumentError)
            end

            it "supports separate arguments" do
                client = ::Bezebe::CVS::CVSClient.new
                expect { client.connect @connection_details[:username], 
                    @connection_details[:password],
                    @connection_details[:host],
                    @connection_details[:repository],
                    nil }.to_not raise_error (ArgumentError)
            end
            it "supports separate arguments with a default port" do
                client = ::Bezebe::CVS::CVSClient.new
                expect { client.connect lient.connect @connection_details[:username], 
                    @connection_details[:password],
                    @connection_details[:host],
                    @connection_details[:repository] }.to_not raise_error (ArgumentError)
            end
        end

        context "when using correct credentials" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                @result = @client1.connect @connection_details
            end

            it "establishes a connection" do
                @result.should be_true
            end

            describe "and the connection" do
                it "is open" do
                   is_open = @client1.is_open?
                   is_open.should be_true 
                end
            end

            context "and when another connection is created" do
                before :each do
                    @client2 = ::Bezebe::CVS::CVSClient.new
                    @result2 = @client2.connect @connection_details
                end

                it "remains open and the new one is open as well" do
                    @client1.is_open?.should be_true
                    @client2.is_open?.should be_true
                end
            end

            context "and when another connection fails to be created" do
                before :each do
                    @client2 = ::Bezebe::CVS::CVSClient.new
                    wrong_connection_details = @connection_details.merge password: "wrongpassword"
                    @result2 = @client2.connect wrong_connection_details
                end

                it "remains opened while the new one doesn't" do
                    @client1.is_open?.should be_true
                    @client2.is_open?.should be_false
                end
            end
        end

        context "when using wrong credentials" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                wrong_connection_details = @connection_details.merge password: "wrongpassword"
                @result = @client1.connect wrong_connection_details
            end

            it "doesn't establish a connection" do
                @result.should be_false
            end

            it "correctly reports the error as an authentication error" do
                @client1.last_error.should_not be_nil
                @client1.last_error.should match /AUTHENTICATION/
            end
        end

        context "when using wrong hostname" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                wrong_connection_details = @connection_details.merge host: "wrongdev.w3.org"
                @result = @client1.connect wrong_connection_details
            end

            it "doesn't establish a connection" do
                @result.should be_false
            end

            it "correctly reports the error as a configuration error" do
                @client1.last_error.should_not be_nil
                @client1.last_error.should match /CONFIGURATION/
            end
        end

    end

end