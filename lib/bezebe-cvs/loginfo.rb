module Bezebe
module CVS
    class LogInfo
        attr_accessor :headRevision, :totalRevisions, :description, :repositoryFilename, :file

        def initialize(logInformation = nil)
            if logInformation.kind_of? Rjb::Rjb_JavaProxy then
                if logInformation._classname == "org.netbeans.lib.cvsclient.command.log.LogInformation" then
                    @headRevision = logInformation.getHeadRevision
                    @totalRevisions = logInformation.getTotalRevisions
                    @description = logInformation.getDescription
                    @repositoryFilename = logInformation.getRepositoryFilename
                    @file = logInformation.getFile
                end
            end
        end
    end
end
end