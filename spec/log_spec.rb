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

        it 'should be able to get information from two known files' do
            log = ::Bezebe::CVS.log [ "file1",
                 "file2",
                 "file3" ]

            puts log.logInfo.to_yaml unless log.nil?
        end

        it 'should be able to get information from a known file' do
            log = ::Bezebe::CVS.log "OffnetPayments_client_4.0.0_rc013.xmlmf"

            puts log.logInfo.to_yaml unless log.nil?
        end

    end

end