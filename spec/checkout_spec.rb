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
            @client1 = ::Bezebe::CVS::CVSClient.new
            @client1.connect "anonymous", "anonymous", "dev.w3.org", nil, "/sources/public"
        end

        it 'should be able to checkout a single file' do
            a = @client1.checkout "w3c/test/foo"
        end

        it 'should be able to checkout two files' do
            b = @client1.checkout [ "w3c/test/foo", "w3c/test/bar" ]
        end

        it 'should have issues to checkout a known file and an unkown one' do
            b = @client1.checkout [ "w3c/test/foo", "w3c/test/somethingthatisnotthere" ]
        end

        it 'should have issues to checkout a known file and an wrong module one' do
            b = @client1.checkout [ "w3c/test/foo", "somefakeroot/w3c/test/somethingthatisnotthere" ]
        end

        it 'should have issues to checkout a known file and an unkown one (again)' do
            b = @client1.checkout [ "w3c/test/foo", "/w3c/test/somethingthatisnotthere" ]
        end

        it 'should have issues to checkout a known file and an wrong module one (again)' do
            b = @client1.checkout [ "w3c/test/foo", "/somefakeroot/w3c/test/somethingthatisnotthere" ]
        end

        it 'should be fast getting a folder' do
            1.times do
                FileUtils.rm_rf "/tmp/w3c/";
                @client1.checkout "w3c"
            end
        end

    end

end