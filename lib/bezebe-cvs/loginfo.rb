module Bezebe
module CVS
    class LogInfo
        attr_accessor :headRevision, :totalRevisions, :description, :repositoryFilename, :file, :branch, :accessList,
                        :selectedRevisions, :keywordSubstitution, :locks, :revisions, :symbolicNames

        def initialize(logInformation = nil)
            begin
                if logInformation.kind_of? Rjb::Rjb_JavaProxy then
                    if logInformation._classname == "org.netbeans.lib.cvsclient.command.log.LogInformation" then
                        @headRevision = logInformation.getHeadRevision
                        @totalRevisions = logInformation.getTotalRevisions
                        @description = logInformation.getDescription
                        @repositoryFilename = logInformation.getRepositoryFilename
                        @file = logInformation.getFile
                        @branch = logInformation.getBranch
                        @accessList = logInformation.getAccessList
                        @selectedRevisions = logInformation.getSelectedRevisions
                        @keywordSubstitution = logInformation.getKeywordSubstitution
                        @locks = logInformation.getLocks
    
                        # list of revisions
                        #@revisions = logInformation.
                        #@revision = ::Bezebe::CVS::Revision.new file_info_event.getInfoContainer.getRevision @logInfo.headRevision
    
                        unless logInformation.getRevisionList.nil? then
                            @revisions = {}
                            revisions = logInformation.getRevisionList.toArray 
                            revisions.each do |revision|
                                new_revision = ::Bezebe::CVS::Revision.new revision
                                @revisions[new_revision.number] = new_revision
                            end
                        end
    
                        # list of symbolic names
                        #@symbolicNames = logInformation.
                    end
                end
            rescue Exception => e
                p e.message
            end
        end
    end 
end
end
