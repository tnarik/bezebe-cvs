require "bezebe-cvs/version"

require "bezebe-cvs/loginfo"
require "bezebe-cvs/revision"
require "bezebe-cvs/cvslistener"

require "rjb"

module Bezebe
  module CVS
    # Your code goes here...

    attr_accessor :connection

    def self.loadJar
        Rjb::load(nil, nil)
        Rjb::add_jar(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), 'vendor' , 'org-netbeans-lib-cvsclient.jar')))
    end

    def self.connect(username, password, host, port = nil, repository = nil)
        loadJar

        @connection = Rjb::import('org.netbeans.lib.cvsclient.connection.PServerConnection').new
        scrambler = Rjb::import('org.netbeans.lib.cvsclient.connection.StandardScrambler').getInstance

        @connection.setUserName username        
        @connection.setEncodedPassword(scrambler.scramble(password))
        @connection.setHostName host
        @connection.setPort port unless port.nil?
        @connection.setRepository repository unless repository.nil?        

        @connection.open
    end

    def self.rlog (filename = nil)
        if @connection.nil?
            puts "a connection is needed first"
            return false
        end

        begin
            standardadminhandler_class = Rjb::import('org.netbeans.lib.cvsclient.admin.StandardAdminHandler')
            client_class = Rjb::import('org.netbeans.lib.cvsclient.Client')
            client = client_class.new(@connection, standardadminhandler_class.new)
            client.setLocalPath "/tmp"

            logcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.log.RlogCommand')
            logcommand = logcommand_class.new
            logcommand.setModule "#{filename}" unless filename.nil?

            a_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')

            event_manager = client.getEventManager
            cvslistener = ::Bezebe::CVS::CvsListener.new
            cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
            event_manager.addCVSListener cvslistener

            client.executeCommand(logcommand, a_class.new)

            puts cvslistener.logInfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts cvslistener.revision.to_yaml

            unless cvslistener.symNames.nil? then
                puts "\nInformation from symbolic names\n"
                names = cvslistener.symNames.toArray 
                names.each do |name|
                    puts "- NAME: #{name.getName}       FOR REVISION: #{name.getRevision}     BRANCH?: #{name.isBranch}"
                end
                puts "\n\n"
            end
        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end
  end
end
