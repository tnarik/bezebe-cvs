require "bezebe-cvs/version"

require "bezebe-cvs/log_info"
require "bezebe-cvs/revision"
require "bezebe-cvs/sym_name"
require "bezebe-cvs/cvslistener"

require "rjb"

module Bezebe
  module CVS
    class CVSClient
        attr_accessor :connection, :last_error

        def initialize
            ::Bezebe::CVS.loadJar
        end

        def connect(username, password, host, port = nil, repository = nil)
            @connection = Rjb::import('org.netbeans.lib.cvsclient.connection.PServerConnection').new
            scrambler = Rjb::import('org.netbeans.lib.cvsclient.connection.StandardScrambler').getInstance
    
            @connection.setUserName username        
            @connection.setEncodedPassword(scrambler.scramble(password))
            @connection.setHostName host
            @connection.setPort port unless port.nil?
            @connection.setRepository repository unless repository.nil?        
    
            begin
                @connection.open
                return true
            rescue AuthenticationException => e
                #p e
                #p e.getMessage
                #p e.printStackTrace
                case e.getMessage
                    when "AuthenticationFailed"
                        @last_error = "AUTHENTICATION ERROR"
                    when "IOException"
                        @last_error = "CONFIGURATION ERROR"
                end
                return false
            end
        end
    
        def is_open?
            return @connection.isOpen
        end
    
        def get_cvs_client
            standardadminhandler_class = Rjb::import('org.netbeans.lib.cvsclient.admin.StandardAdminHandler')
            client_class = Rjb::import('org.netbeans.lib.cvsclient.Client')
            client = client_class.new(@connection, standardadminhandler_class.new)
    
            return client
        end
    
        def update
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
    
        def checkout (filenames = nil)
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
    
        def status (filenames = nil)
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
    
        def log (filenames = nil)
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
    
        def rlog (filenames = nil)
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
end
