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

        it 'should be able to checkout a single file' do
            a = ::Bezebe::CVS.checkout "w3c/test/foo"
        end

        it 'should be able to checkout two files' do
            b = ::Bezebe::CVS.checkout [ "w3c/test/foo", "w3c/test/bar" ]
        end

        it 'should have issues to checkout a known file and an unkown one' do
            b = ::Bezebe::CVS.checkout [ "w3c/test/foo", "w3c/test/somethingthatisnotthere" ]
        end

        it 'should have issues to checkout a known file and an wrong module one' do
            b = ::Bezebe::CVS.checkout [ "w3c/test/foo", "somefakeroot/w3c/test/somethingthatisnotthere" ]
        end

        it 'should have issues to checkout a known file and an unkown one (again)' do
            b = ::Bezebe::CVS.checkout [ "w3c/test/foo", "/w3c/test/somethingthatisnotthere" ]
        end

        it 'should have issues to checkout a known file and an wrong module one (again)' do
            b = ::Bezebe::CVS.checkout [ "w3c/test/foo", "/somefakeroot/w3c/test/somethingthatisnotthere" ]
        end
    end

end