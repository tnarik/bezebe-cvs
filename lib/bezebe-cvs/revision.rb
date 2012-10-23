module Bezebe
module CVS
    class Revision
        attr_accessor :number, :author, :message, :state, :lines, :dateString, :commitID, :branches

        def initialize(revision = nil)
            if revision.kind_of? Rjb::Rjb_JavaProxy then
                if revision._classname == "org.netbeans.lib.cvsclient.command.log.LogInformation$Revision" then
                    @number = revision.getNumber
                    @author = revision.getAuthor
                    @message = revision.getMessage
                    @state = revision.getState
                    @lines = revision.getLines
                    @dateString = revision.getDateString
                    @commitID = revision.getCommitID
                    @branches = revision.getBranches
                end
            end
        end
    end
end
end