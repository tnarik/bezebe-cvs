require 'spec_helper'

describe Bezebe::CVS::CVSClient do
    describe "the connect method" do

        before :each do
            #::Bezebe::CVS.stub!(:puts)
            #::Bezebe::CVS.stub!(:p)
            #stub!(:puts)
            #stub!(:p)
        end

        context "when using correct credentials" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                @result = @client1.connect "anonymous", "anonymous", "dev.w3.org", nil, "/sources/public"
            end

            it "should establish a connection" do
                @result.should be_true
            end

            describe "and the connection" do
                it "should be opened" do
                   is_open = @client1.is_open?
                   is_open.should be_true 
                end
            end

            describe "and if another connection is created" do
                before :each do
                    @client2 = ::Bezebe::CVS::CVSClient.new
                    @result2 = @client2.connect "anonymous", "anonymous", "dev.w3.org", nil, "/sources/public"
                end

                it "both should be opened" do
                    @client1.is_open?.should be_true
                    @client2.is_open?.should be_true
                end
            end
        end

        context "when using wrong credentials" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                @result = @client1.connect "anonymous", "wrongpassword", "dev.w3.org", nil, "/sources/public"
            end

            it "shouldn't establish a connection" do
                @result.should be_false
            end

            it "should correctly report the error as an Authentication error" do
                @client1.last_error.should_not be_nil
                @client1.last_error.should match /AUTHENTICATION/
            end
        end

        context "when using wrong hostname" do
            before :each do
                @client1 = ::Bezebe::CVS::CVSClient.new
                @result = @client1.connect "anonymous", "anonymous", "wrongdev.w3.org", nil, "/sources/public"
            end

            it "shouldn't establish a connection" do
                @result.should be_false
            end

            it "should correctly report the error as an configuration error" do
                @client1.last_error.should_not be_nil
                @client1.last_error.should match /CONFIGURATION/
            end
        end

    end

end