module Bezebe
module CVS
    class CvsListener

        ERRORMESSAGERESPONSE_CLASS = "org.netbeans.lib.cvsclient.response.ErrorMessageResponse"
        LOGINFORMATION_CLASS = "org.netbeans.lib.cvsclient.command.log.LogInformation"
        STATUSINFORMATION_CLASS = "org.netbeans.lib.cvsclient.command.status.StatusInformation"

        attr_accessor :logInfo, :logInfos, :client

        def messageSent (message_event)
            #p "sent"
            #p message_event.getMessage if !message_event.getMessage.empty?
            #p message_event.isError if message_event.isError
            #p message_event.isTagged
            #p message_event.toString
            #p message_event.getSource._classname
            if message_event.getSource._classname == ERRORMESSAGERESPONSE_CLASS then
                if message_event.getSource.getMessage =~ /\[server\ aborted\]/ then
                    client.abort
                end
            end
        end
        def fileAdded (file_added_event)
            #p "added"
        end
        def fileToRemove (file_to_remove_event)
            #p "toremove"
        end
        def fileRemoved (file_removed_event)
            #p "removed"
        end
        def fileUpdated (file_updated_event)
            #p "updated"
        end
        def fileInfoGenerated (file_info_event)
            #p "info"
            if file_info_event.getInfoContainer._classname == LOGINFORMATION_CLASS then
                @logInfo = ::Bezebe::CVS::LogInfo.new file_info_event.getInfoContainer
                @logInfos = [] if @logInfos.nil?;
                @logInfos << @logInfo
            end
            if file_info_event.getInfoContainer._classname == STATUSINFORMATION_CLASS then
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
            #p "terminated"
        end
        def moduleExpanded (module_expansion_event)
            #p "expanded"
        end
    end
end
end