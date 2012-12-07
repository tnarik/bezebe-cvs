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
        attr_accessor :standardadminhandler_class, :client_class, :checkoutcommand_class, :statuscommand_class, :logcommand_class, :rlogcommand_class, :global_options_class

        def connection=(connection_details)
            @connection = Rjb::import('org.netbeans.lib.cvsclient.connection.PServerConnection').new
            scrambler = Rjb::import('org.netbeans.lib.cvsclient.connection.StandardScrambler').getInstance

            if connection_details.size == 1 then
                connection_details = connection_details[0]

                @connection.setUserName connection_details[:username]
                @connection.setEncodedPassword(scrambler.scramble(connection_details[:password]))
                @connection.setHostName connection_details[:host]
                @connection.setRepository connection_details[:repository] unless connection_details[:repository].nil?
                @connection.setPort connection_details[:port] unless connection_details[:port].nil?
            elsif connection_details.size >= 4 then
                @connection.setUserName connection_details[0]        
                @connection.setEncodedPassword(scrambler.scramble(connection_details[1]))
                @connection.setHostName connection_details[2]
                @connection.setRepository connection_details[3] unless connection_details[3].nil?   
                @connection.setPort connection_details[4] unless connection_details[4].nil?
            end
            @connection
        end
        private :connection=

        def initialize (*connection_details)
            ::Bezebe::CVS.loadJar
            self.connection = connection_details unless connection_details.empty?

            self.standardadminhandler_class = Rjb::import('org.netbeans.lib.cvsclient.admin.StandardAdminHandler')
            self.client_class = Rjb::import('org.netbeans.lib.cvsclient.Client')
            self.checkoutcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.checkout.CheckoutCommand')
            self.statuscommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.status.StatusCommand')
            self.logcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.log.LogCommand')
            self.rlogcommand_class = Rjb::import('org.netbeans.lib.cvsclient.command.log.RlogCommand')
            
            self.global_options_class = Rjb::import('org.netbeans.lib.cvsclient.command.GlobalOptions')
        end

        def connect(*connection_details)
            self.connection = connection_details unless connection_details.empty?
                
            begin
                client = get_cvs_client
                client.ensureConnection
                return true
            rescue => e
                begin
                    if e._classname == "org.netbeans.lib.cvsclient.connection.AuthenticationException" then
                        @last_error = {}
                        @last_error[:message] = e.getMessage
                        @last_error[:localized_message] = e.getLocalizedMessage
                        @last_error[:cause] = e.getCause.nil? ? "" : e.getCause.toString
                        case e.getMessage
                            when "AuthenticationFailed"
                                @last_error[:type] = AUTHENTICATION_ERROR
                            when "IOException"
                                @last_error[:type] = COMMUNICATION_ERROR
                            when "ConnectException"
                                @last_error[:type] = CONNECTION_ERROR
                            when "Timeout, no response from server."
                                @last_error[:type] = TIMEOUT_ERROR
                                # Let's make sure the connection is closed
                                @connection.close

                        end
                    end
                rescue NoMethodError => e
                    # The error doesn't respond to RJB derived methods
                    return false
                end
                return false
            end
        end
    
        def is_connected?
            #p @connection
            #p @connection.isOpen
            return @connection.isOpen
        end
    
        def get_cvs_client
            client = self.client_class.new(@connection, self.standardadminhandler_class.new)
    
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
            ensure
                event_manager.removeCVSListener cvslistener
                Rjb::unbind(cvslistener)
            end
        end
    
        def checkout (path, filenames = nil)
            if @connection.nil?
                puts "a connection is needed first"
                return false
            end
    
            begin
                client = get_cvs_client
                client.setLocalPath path
    
                checkoutcommand = self.checkoutcommand_class.new
    
                checkoutcommand.setModule "#{filenames}" unless filenames.nil? or filenames.is_a? Array
                filenames.each { |m| checkoutcommand.setModule "#{m}" } unless filenames.nil? or !filenames.is_a? Array
    
                a = self.global_options_class.new
    
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
            ensure
                event_manager.removeCVSListener cvslistener
                Rjb::unbind(cvslistener)
            end
        end
    
        def status (path, filenames = nil)
            if @connection.nil?
                puts "a connection is needed first"
                return false
            end
    
            begin
                client = get_cvs_client
                client.setLocalPath path
    
                statuscommand = self.statuscommand_class.new
        
                file_class = Rjb::import('java.io.File')
                files = []
                files << ( file_class.new  filenames ) unless filenames.nil? or filenames.is_a? Array
                filenames.each { |m| files << ( file_class.new m) } unless filenames.nil? or !filenames.is_a? Array
                statuscommand.setFiles files
    
                a = self.global_options_class.new
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
            ensure
                event_manager.removeCVSListener cvslistener
                Rjb::unbind(cvslistener)
            end
        end
    
        def log (path, filenames = nil)
            if @connection.nil?
                puts "a connection is needed first"
                return false
            end
    
            begin
                client = get_cvs_client
                client.setLocalPath path
    
                logcommand = self.logcommand_class.new
        
                file_class = Rjb::import('java.io.File')
                files = []
                files << ( file_class.new  filenames ) unless filenames.nil? or filenames.is_a? Array
                filenames.each { |m| files << ( file_class.new m) } unless filenames.nil? or !filenames.is_a? Array
                logcommand.setFiles files
    
                a = self.global_options_class.new
    
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
            ensure
                event_manager.removeCVSListener cvslistener
                Rjb::unbind(cvslistener)
            end
        end
    
        def rlog (filenames = nil)
            if @connection.nil?
                puts "a connection is needed first"
                return false
            end
    
            begin
                client = get_cvs_client
    
                rlogcommand = self.rlogcommand_class.new
    
                rlogcommand.setModule "#{filenames}" unless filenames.nil? or filenames.is_a? Array
                filenames.each { |m| rlogcommand.setModule "#{m}" } unless filenames.nil? or !filenames.is_a? Array
    
                event_manager = client.getEventManager
                cvslistener = ::Bezebe::CVS::CvsListener.new
                cvslistener = Rjb::bind(cvslistener, 'org.netbeans.lib.cvsclient.event.CVSListener')
                event_manager.addCVSListener cvslistener
    
                client.executeCommand(rlogcommand, self.global_options_class.new)
                return cvslistener
            rescue Exception => e
                p e
            rescue AuthenticationException => e
                p e.getMessage
                p e.printStackTrace
            ensure
                event_manager.removeCVSListener cvslistener
                Rjb::unbind(cvslistener)
            end
        end
    end
end
end
