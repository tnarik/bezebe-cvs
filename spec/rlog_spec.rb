require 'spec_helper'

describe Bezebe::CVS do
  it 'should be able to connect to a know repository as W3' do
    ::Bezebe::CVS.connect "anonymous", "anonymous", "dev.w3.org", nil, "/sources/public"
    ::Bezebe::CVS.rlog "w3c/test/foo"
  end

  it 'should not connect if credentials are wrong'

  it 'should be able to perform a rlog'
end
