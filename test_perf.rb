require 'bezebe-cvs'
require 'yaml'

def ggg_func()

Ti.API.debug("this is some RUBY script");
window1=Ti.UI.getMainWindow()
#window2=Ti.UI.getCurrentWindow()
window1.setTitle("new title 1")
#window2.setTitle("new title 2")

domwindow1=window1.getDOMWindow()
puts domwindow1.document.getElementById('numberofinfos').innerHTML
#puts domwindow1.newVar
puts "ggg"
#$stdout.flush

#puts window.thiswindow
#puts thiswindow


end

class A 
variable="tst"

attr_accessor :counter, :window1, :domwindow1
def initialize
    @counter=0
    
    puts RUBY_VERSION
    $stdout.flush
    
    puts "=========="
    puts RUBY_VERSION
    puts RUBY_PLATFORM
    #require 'nokogiri' #doesnt work because it builds as 64 bits, but runs as universal
    
    require 'bezebe-cvs'
    puts Bezebe::CVS::VERSION

    @a_client = ::Bezebe::CVS::CVSClient.new "anonymous", "anonymous", "dev.w3.org", "/sources/public"

    #self.window1=Ti.UI.getMainWindow()
    #self.domwindow1=self.window1.getDOMWindow()
end

def echolo()
    puts "echoolooo"
    $stdout.flush
end

def a_new
    @counter=0
    @a_client = nil
    @a_client = ::Bezebe::CVS::CVSClient.new "anonymous", "anonymous", "dev.w3.org", "/sources/public"
end

def clean_mem
    GC.start   # collect unused objects if need
end

def count_objects
    GC.start   # collect unused objects if need
    p = {}
    #s = ''
    i = 0
    ObjectSpace.each_object do |o|
        #s << "#{o.class}, #{o.object_id}, #{o.inspect}"
        p["#{o.class}"] = {} if p["#{o.class}"].nil?
        p["#{o.class}"][:number] = 0 if p["#{o.class}"][:number].nil?
        p["#{o.class}"][:size] = 0 if p["#{o.class}"][:size].nil?
        p["#{o.class}"][:number] += 1
        p["#{o.class}"][:size] += o.size if o.instance_of? String
        p["#{o.class}"][:size] += o.size if o.instance_of? Array
        p["#{o.class}"][:size] += o.size if o.instance_of? Hash

        i += 1
    end
    #s << "- total objects = #{i}"
    
    #window1=Ti.UI.getMainWindow()
    #domwindow1=window1.getDOMWindow()
    #domwindow1.document.getElementById('numberofobjects').innerHTML="#{i}"

    strout = ''
    p_keys = p.keys.sort
    p_keys.each { |k|
        strout << "number of #{k}  = #{p[k][:number]} (#{p[k][:size]})\n"
    }

    File.open("/tmp/dump_#{self.counter}.txt", 'w') { |f| f.write(strout)}
end

def testa()
    puts "test"
    $stdout.flush
end

def do_the_dom()
    
    require 'yaml'
    
    puts global_variables.to_yaml
    puts instance_variables.to_yaml
    
    puts local_variables.to_yaml
    #$window.alert "alert! alert!"
end

def do_the_java_s()
    #window1=Ti.UI.getMainWindow()
    
    #domwindow1=window1.getDOMWindow()
    #domwindow1.replace_number_of_infos()
end

def do_the_java()
    # enable object dumping every 500 steps
    if ( self.counter % 500 == 0 ) then
        self.count_objects
    end
    
    self.counter+=1
    
    #@another_client = ::Bezebe::CVS::CVSClient.new "anonymous", "anonymous", "dev.w3.org", "/sources/public"
    
    rlog = @a_client.rlog "w3c/test"
    #puts rlog.logInfo.to_yaml
    
    #puts rlog.logInfo.revisions.size  
    new_text= "#{counter}"
    #new_text << " - #{rlog.logInfos.size}" unless rlog.nil?
    #puts new_text
    #self.domwindow1.document.getElementById('numberofinfos').innerHTML=new_text
end

end

a = A.new

puts "#{:TOTAL} / #{:FREE} / #{:T_HASH} / #{:T_STRING} / #{:T_OBJECT} "

i=0
1000.times do 
    i+=1
    if ( i % 20 == 0 ) then
        h = ObjectSpace.count_objects
        #puts "TOTAL: #{h[:TOTAL]} / #{h[:FREE]}"
        puts "#{h[:TOTAL]} / #{h[:FREE]} / #{h[:T_HASH]} / #{h[:T_STRING]} / #{h[:T_OBJECT]} "
        puts "======================="
    end
    a.do_the_java()
end
puts 1000
GC.start

h = ObjectSpace.count_objects
#puts "TOTAL: #{h[:TOTAL]} / #{h[:FREE]}"
puts "#{h[:TOTAL]} / #{h[:FREE]} / #{h[:T_HASH]} / #{h[:T_STRING]} / #{h[:T_OBJECT]} "
sleep 10000
puts "======================="


