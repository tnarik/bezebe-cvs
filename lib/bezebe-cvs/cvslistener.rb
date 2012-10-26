module Bezebe
module CVS
    class CvsListener

        attr_accessor :logInfo, :logInfos

        def messageSent (message_event)
            p "sent"
        end
        def fileAdded (file_added_event)
            p "added"
        end
        def fileToRemove (file_to_remove_event)
            p "toremove"
        end
        def fileRemoved (file_removed_event)
            p "removed"
        end
        def fileUpdated (file_updated_event)
            p "updated"
        end
        def fileInfoGenerated (file_info_event)
            p "info"
            if file_info_event.getInfoContainer._classname == "org.netbeans.lib.cvsclient.command.log.LogInformation" then
                @logInfo = ::Bezebe::CVS::LogInfo.new file_info_event.getInfoContainer
                @logInfos = [] if @logInfos.nil?;
                @logInfos << @logInfo
            end
            if file_info_event.getInfoContainer._classname == "org.netbeans.lib.cvsclient.command.status.StatusInformation" then
                p "some status information to be processed"
                p file_info_event.getInfoContainer.getRepositoryRevision
                p file_info_event.getInfoContainer.getWorkingRevision
                p file_info_event.getInfoContainer.getStatusString
                p file_info_event.getInfoContainer.getStickyDate
                p file_info_event.getInfoContainer.getStickyOptions
                p file_info_event.getInfoContainer.getStickyTag

                p file_info_event.getInfoContainer.getRepositoryFileName
            end
            return nil
        end
        def commandTerminated (termination_event)
            p "terminated"
        end
        def moduleExpanded (module_expansion_event)
            p "expanded"
        end
    end
end
end