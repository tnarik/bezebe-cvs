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
        end

        context "when using wrong credentials" do
            it "shouldn't establish a connection" do
                client1 = ::Bezebe::CVS::CVSClient.new
                result = client1.connect "anonymous", "wrongpassword", "dev.w3.org", nil, "/sources/public"
                result.should be_false
                p client1.last_error
            end
        end

        context "when using wrong hostname" do
            it "shouldn't establish a connection" do
                client1 = ::Bezebe::CVS::CVSClient.new
                result = client1.connect "anonymous", "anonymous", "wrongdev.w3.org", nil, "/sources/public"
                result.should be_false
                p client1.last_error
            end
        end

    end

end