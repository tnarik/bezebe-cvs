module Bezebe
module CVS
    class CvsListener

        attr_accessor :logInfo, :logInfos

        def messageSent (message_event)
        end
        def fileAdded (file_added_event)
        end
        def fileToRemove (file_to_remove_event)
        end
        def fileRemoved (file_removed_event)
        end
        def fileUpdated (file_updated_event)
        end
        def fileInfoGenerated (file_info_event)
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
        end
        def moduleExpanded (module_expansion_event)
        end
    end
end
end