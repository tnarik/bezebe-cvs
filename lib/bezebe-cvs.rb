require "bezebe-cvs/version"

require "bezebe-cvs/log_info"
require "bezebe-cvs/revision"
require "bezebe-cvs/sym_name"
require "bezebe-cvs/cvslistener"

require "rjb"

module Bezebe
  module CVS
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

    def self.get_cvs_client
        standardadminhandler_class = Rjb::import('org.netbeans.lib.cvsclient.admin.StandardAdminHandler')
        client_class = Rjb::import('org.netbeans.lib.cvsclient.Client')
        client = client_class.new(@connection, standardadminhandler_class.new)

        return client
    end

    def self.update
        if @connection.nil?
            puts "a connection is needed first"
            return false
        end

        begin
            client = get_cvs_client
            client.setLocalPath "/tmp/w3c/test/"
        rescue Exception => e
            p e
        rescue CommandException => e
            p e.printStackTrace
        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end

    def self.checkout (filenames = nil)
        if @connection.nil?
            puts "a connection is needed first"
            return false
        end

        begin
            client = get_cvs_client
            client.setLocalPath "/tmp/"

            checkoutcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.checkout.CheckoutCommand')
            checkoutcommand = checkoutcommand_class.new

            checkoutcommand.setModule "#{filenames}" unless filenames.nil? or filenames.is_a? Array
            filenames.each { |m| checkoutcommand.setModule "#{m}" } unless filenames.nil? or !filenames.is_a? Array

            a_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')
            a = a_class.new

            event_manager = client.getEventManager
            cvslistener = ::Bezebe::CVS::CvsListener.new
            cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
            cvslistener.client = client
            event_manager.addCVSListener cvslistener

            client.executeCommand(checkoutcommand, a)
        rescue => e
            p e
        rescue CommandAbortedException => e
            p e.printStackTrace
        rescue CommandException => e
            p e.printStackTrace
        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end
 
    def self.status (filenames = nil)
        if @connection.nil?
            puts "a connection is needed first"
            return false
        end

        begin
            client = get_cvs_client
            client.setLocalPath "/tmp/w3c/test/"

            statuscommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.status.StatusCommand')
            statuscommand = statuscommand_class.new
    
            file_class = Rjb::import('java.io.File')
            files = []
            files << ( file_class.new  filenames ) unless filenames.nil? or filenames.is_a? Array
            filenames.each { |m| files << ( file_class.new m) } unless filenames.nil? or !filenames.is_a? Array
            statuscommand.setFiles files

            a_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')
            a = a_class.new
            #a.setTraceExecution true

            event_manager = client.getEventManager
            cvslistener = ::Bezebe::CVS::CvsListener.new
            cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
            event_manager.addCVSListener cvslistener

            client.executeCommand(statuscommand, a)
            return cvslistener
        rescue Exception => e
            p e
        rescue CommandException => e
            p e.printStackTrace
        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end

    def self.log (filenames = nil)
        if @connection.nil?
            puts "a connection is needed first"
            return false
        end

        begin
            client = get_cvs_client
            client.setLocalPath "/tmp/w3c/test/"

            logcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.log.LogCommand')
            logcommand = logcommand_class.new
    
            file_class = Rjb::import('java.io.File')
            files = []
            files << ( file_class.new  filenames ) unless filenames.nil? or filenames.is_a? Array
            filenames.each { |m| files << ( file_class.new m) } unless filenames.nil? or !filenames.is_a? Array
            logcommand.setFiles files

            a_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')
            a = a_class.new
            #a.setTraceExecution true

            event_manager = client.getEventManager
            cvslistener = ::Bezebe::CVS::CvsListener.new
            cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
            event_manager.addCVSListener cvslistener

            client.executeCommand(logcommand, a)
            return cvslistener
        rescue Exception => e
            p e
        rescue CommandException => e
            p e.printStackTrace
        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end

    def self.rlog (filenames = nil)
        if @connection.nil?
            puts "a connection is needed first"
            return false
        end

        begin
            client = get_cvs_client
            #client.setLocalPath "/tmp"

            logcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.log.RlogCommand')
            logcommand = logcommand_class.new

            logcommand.setModule "#{filenames}" unless filenames.nil? or filenames.is_a? Array
            filenames.each { |m| logcommand.setModule "#{m}" } unless filenames.nil? or !filenames.is_a? Array

            a_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')

            event_manager = client.getEventManager
            cvslistener = ::Bezebe::CVS::CvsListener.new
            cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
            event_manager.addCVSListener cvslistener

            client.executeCommand(logcommand, a_class.new)
            return cvslistener
        rescue Exception => e
            p e
        rescue AuthenticationException => e
            p e.getMessage
            p e.printStackTrace
        end
    end
  end
end
