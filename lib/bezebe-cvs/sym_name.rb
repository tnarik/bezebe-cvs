module Bezebe
module CVS
    class SymName
        attr_accessor :name, :revision

        def initialize(symName = nil)
            if symName.kind_of? Rjb::Rjb_JavaProxy then
                if symName._classname == "org.netbeans.lib.cvsclient.command.log.LogInformation$SymName" then
                    @name = symName.getName
                    @revision = symName.getRevision
                    @branch = symName.isBranch
                end
            end
        end

        def isBranch?
            return @branch;
        end
    end
end
end
