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
                        self.revisions = {}
                        unless logInformation.getRevisionList.nil? then
                            revisions = logInformation.getRevisionList.toArray 
                            revisions.each do |revision|
                                new_revision = ::Bezebe::CVS::Revision.new revision
                                self.revisions[new_revision.number] = new_revision
                            end
                        end
    
                        # list of symbolic names
                        self.symbolicNames = {}
                        unless logInformation.getAllSymbolicNames.nil? then
                            symbolicNames = logInformation.getAllSymbolicNames.toArray 
                            symbolicNames.each do |symbolicName|
                                new_symbolicName = ::Bezebe::CVS::SymName.new symbolicName
                                self.symbolicNames[new_symbolicName.name] = new_symbolicName
                            end
                        end
                    end
                end
            rescue Exception => e
                p e.message
            end
        end

        def symName_for_revision (revision)
            list = []
            self.symbolicNames.each do |k, symbolicName|
                list << symbolicName if k == revision
            end
            return list;
        end
    end 
end
end
