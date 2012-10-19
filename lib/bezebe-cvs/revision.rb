module Bezebe
module CVS
    class Revision
        attr_accessor :number, :author, :message, :state, :lines, :dateString

        def initialize(revision = nil)
            if revision.kind_of? Rjb::Rjb_JavaProxy then
                if revision._classname == "org.netbeans.lib.cvsclient.command.log.LogInformation$Revision" then
                    @number = revision.getNumber
                    @author = revision.getAuthor
                    @message = revision.getMessage
                    @state = revision.getState
                    @lines = revision.getLines
                    @dateString = revision.getDateString
                end
            end
        end
    end
end
end