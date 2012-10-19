require "bezebe-cvs/version"

require "bezebe-cvs/loginfo"
require "bezebe-cvs/revision"
require "bezebe-cvs/cvslistener"

require "rjb"

module Bezebe
  module CVS
    # Your code goes here...


    def self.rlog (filename = nil)
        Rjb::load(nil, nil)
        Rjb::add_jar(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), 'vendor' , 'org-netbeans-lib-cvsclient.jar')))

        begin
            pserverconnection_class = Rjb::import('org.netbeans.lib.cvsclient.connection.PServerConnection')
            scrambler_class = Rjb::import('org.netbeans.lib.cvsclient.connection.StandardScrambler')

            pserverconnection = pserverconnection_class.new
            pserverconnection.setUserName "username"
            scrambler = scrambler_class.getInstance
            pserverconnection.setEncodedPassword(scrambler.scramble("password"))
            pserverconnection.setHostName "host"
            pserverconnection.setPort 2401
            pserverconnection.setRepository "/opt/cvs/us"        
            pserverconnection.open

            standardadminhandler_class = Rjb::import('org.netbeans.lib.cvsclient.admin.StandardAdminHandler')
            client_class = Rjb::import('org.netbeans.lib.cvsclient.Client')
            client = client_class.new(pserverconnection, standardadminhandler_class.new)
            client.setLocalPath "/tmp"

            logcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.log.RlogCommand')
            logcommand = logcommand_class.new

            file_class = Rjb::import('java.io.File')
            file = file_class.new "resources/ReleaseNote.xml"
            logcommand.setModule "samplefile/module" if filename.nil?
            logcommand.setModule "#{filename}" unless filename.nil?

            a_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')

            event_manager = client.getEventManager
            cvslistener = ::Bezebe::CVS::CvsListener.new
            cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
            event_manager.addCVSListener cvslistener

            client.executeCommand(logcommand, a_class.new)

        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end
  end
end
