module Bezebe
module CVS
    class CvsListener

        attr_accessor :logInfo, :revision, :symNames

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
            @logInfo = ::Bezebe::CVS::LogInfo.new file_info_event.getInfoContainer
            return nil
        end
        def commandTerminated (termination_event)
        end
        def moduleExpanded (module_expansion_event)
        end
    end
end
end