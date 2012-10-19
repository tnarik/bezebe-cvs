module Bezebe
module CVS
    class CvsListener
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
            loginfo = ::Bezebe::CVS::LogInfo.new file_info_event.getInfoContainer
            rev = ::Bezebe::CVS::Revision.new file_info_event.getInfoContainer.getRevision loginfo.headRevision

            puts loginfo.to_yaml
            puts "\nInformation from HEAD release\n"
            puts rev.to_yaml

            puts "\nInformation from symbolic names\n"
            revision_sym_names = file_info_event.getInfoContainer.getSymNamesForRevision rev.number
            names = revision_sym_names.toArray
            names.each do |name|
                puts "- NAME: #{name.getName}       FOR REVISION: #{name.getRevision}     BRANCH?: #{name.isBranch}"
            end
            puts "\n\n"

        end
        def commandTerminated (termination_event)
        end
        def moduleExpanded (module_expansion_event)
        end
    end
end
end