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
            ::Bezebe::CVS.stub!(:puts)
            ::Bezebe::CVS.stub!(:p)

            ::Bezebe::CVS.connect "anonymous", "anonymous", "dev.w3.org", nil, "/sources/public"
        end

        it 'should be able to get information from a known file' do
            ::Bezebe::CVS.rlog "w3c/test/foo"
        end

        it 'should not be able to get information from an unknown file' do
            ::Bezebe::CVS.rlog "w3c/test/this_doesnt_exist"
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