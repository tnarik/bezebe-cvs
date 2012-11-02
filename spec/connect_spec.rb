require 'spec_helper'

describe Bezebe::CVS::CVSClient do

    it "responds to #connect" do
        should respond_to(:connect)
    end

    describe "#connect" do

        before :all do
            @client = ::Bezebe::CVS::CVSClient.new
            @connection_details = FactoryGirl.build(:connection_details)
            @connection_details_attributes = FactoryGirl.attributes_for(:connection_details)

            #::Bezebe::CVS.stub!(:puts)
            #::Bezebe::CVS.stub!(:p)
            #stub!(:puts)
            #stub!(:p)
        end


        context "regarding parameters" do
            it "supports a hash" do
                expect { @client.connect @connection_details_attributes }.to_not raise_error (ArgumentError)
            end

            it "supports separate arguments" do
                expect { @client.connect @connection_details.username, 
                    @connection_details.password,
                    @connection_details.host,
                    @connection_details.repository,
                    @connection_details.port }.to_not raise_error (ArgumentError)
            end
            it "supports separate arguments with a default port" do
                expect { @client.connect @connection_details.username, 
                    @connection_details.password,
                    @connection_details.host,
                    @connection_details.repository }.to_not raise_error (ArgumentError)
            end
        end


        context "when using correct credentials" do
            before :each do
                @client_connected = @client.connect @connection_details_attributes
            end

            it "reports establishing a connection" do
                @connection_details_attributes.should be_true
            end

            it "reports being connected" do
                @client.is_connected?.should be_true 
            end

            context "and when another client connects" do
                before :each do
                    @another_client = ::Bezebe::CVS::CVSClient.new
                    @another_client_connected = @another_client.connect @connection_details_attributes
                end

                it "remains connected and the new one is connected as well" do
                    @client.is_connected?.should be_true
                    @another_client.is_connected?.should be_true
                end
            end

            context "and when another client fails to connect" do
                before :each do
                    @another_client = ::Bezebe::CVS::CVSClient.new
                    @another_client_connected = @another_client.connect FactoryGirl.attributes_for(:connection_details, password: "wrongpassword")
                end

                it "remains connected while the new one doesn't" do
                    @client.is_connected?.should be_true
                    @another_client.is_connected?.should be_false
                end
            end
        end


        context "when using wrong credentials" do
            before :each do
                @client_connected = @client.connect FactoryGirl.attributes_for(:connection_details, password: "wrongpassword")
            end

            it "reports not establishing a connection" do
                @client_connected.should be_false
            end

            it "reports not being connected" do
                @client.is_connected?.should be_false 
            end

            it "reports the error as an authentication error" do
                @client.last_error.should_not be_nil
                expect(@client.last_error[:type]).to eq(Bezebe::CVS::AUTHENTICATION_ERROR)
            end
        end


        context "when using wrong hostname" do
            before :each do
                @client_connected = @client.connect FactoryGirl.attributes_for(:connection_details, host: "wronghost")
            end

            it "reports not establishing a connection" do
                @client_connected.should be_false
            end

            it "reports not being connected" do
                @client.is_connected?.should be_false 
            end

            it "reports the error as a communication error" do
                @client.last_error.should_not be_nil
                expect(@client.last_error[:type]).to eq(Bezebe::CVS::COMMUNICATION_ERROR)
            end
        end

    end

end