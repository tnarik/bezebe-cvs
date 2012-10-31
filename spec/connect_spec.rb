require 'spec_helper'

describe Bezebe::CVS::CVSClient do

    it { should respond_to(:connect) }

    describe "#connect" do

        before :all do
            #::Bezebe::CVS.stub!(:puts)
            #::Bezebe::CVS.stub!(:p)
            #stub!(:puts)
            #stub!(:p)
        end

        context "regarding parameters" do
            it "supports a hash" do
                client = ::Bezebe::CVS::CVSClient.new
                expect { client.connect @connection_details }.to_not raise_error (ArgumentError)
            end

            it "supports separate arguments" do
                client = ::Bezebe::CVS::CVSClient.new
                connection_details = FactoryGirl.build(:connection_details)
                expect { client.connect connection_details.username, 
                    connection_details.password,
                    connection_details.host,
                    connection_details.repository,
                    connection_details.port }.to_not raise_error (ArgumentError)
            end
            it "supports separate arguments with a default port" do
                client = ::Bezebe::CVS::CVSClient.new
                connection_details = FactoryGirl.build(:connection_details)
                expect { client.connect connection_details.username, 
                    connection_details.password,
                    connection_details.host,
                    connection_details.repository }.to_not raise_error (ArgumentError)
            end
        end

        context "when using correct credentials" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                @result = @client1.connect FactoryGirl.attributes_for(:connection_details)
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
                    @result2 = @client2.connect FactoryGirl.attributes_for(:connection_details)
                end

                it "remains open and the new one is open as well" do
                    @client1.is_open?.should be_true
                    @client2.is_open?.should be_true
                end
            end

            context "and when another connection fails to be created" do
                before :each do
                    @client2 = ::Bezebe::CVS::CVSClient.new
                    @result2 = @client2.connect FactoryGirl.attributes_for(:connection_details, password: "wrongpassword")
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
                @result = @client1.connect FactoryGirl.attributes_for(:connection_details, password: "wrongpassword")
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
                @result = @client1.connect FactoryGirl.attributes_for(:connection_details, host: "wrongdev.w3.org")
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