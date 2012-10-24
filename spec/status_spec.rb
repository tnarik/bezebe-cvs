require 'spec_helper'

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

            ::Bezebe::CVS.connect "anonymous", "anonymous", "dev.w3.org", nil, "/sources/public"
        end

        it 'should be able to get information from a known file' do
            status = ::Bezebe::CVS.status "/tmp/w3c/test/foo"
            puts status.logInfo.to_yaml unless status.nil?
        end

        it 'should be able to get information from two known files' do
            status = ::Bezebe::CVS.status [ "/tmp/w3c/test/foo", "/tmp/w3c/test/bar" ]
            puts status.logInfo.to_yaml unless status.nil?
        end

    end

end