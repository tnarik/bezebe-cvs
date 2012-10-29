require "bezebe-cvs/version"

require "bezebe-cvs/log_info"
require "bezebe-cvs/revision"
require "bezebe-cvs/sym_name"
require "bezebe-cvs/cvslistener"
require "bezebe-cvs/cvs_client"

require "rjb"

module Bezebe
    module CVS
        def self.loadJar
            Rjb::load(nil, nil)
            Rjb::add_jar(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), 'vendor' , 'org-netbeans-lib-cvsclient.jar')))
        end
    end
end
