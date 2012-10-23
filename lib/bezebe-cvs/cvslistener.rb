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
            @revision = ::Bezebe::CVS::Revision.new file_info_event.getInfoContainer.getRevision @logInfo.headRevision

            unless file_info_event.getInfoContainer.getAllSymbolicNames.nil? then
                @symNames = {}

                names = file_info_event.getInfoContainer.getAllSymbolicNames.toArray 
                names.each do |name|
                    new_symName = ::Bezebe::CVS::SymName.new name
                    @symNames[new_symName.revision] = new_symName
                end
            end
        end
        def commandTerminated (termination_event)
        end
        def moduleExpanded (module_expansion_event)
        end
    end
end
end