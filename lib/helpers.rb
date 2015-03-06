require 'nanoc/toolbox'

include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo
include Nanoc::Toolbox::Helpers::HtmlTag

class Nanoc::Context
  class << self
    def item_digests
      @item_digests ||= {}
    end
  end
end

def body_attrs
  {}
end

# def copy_for(identifier)
#   item_for("/copy#{@item.identifier[7..-1]}#{identifier}/")
# end

# def render_copy(identifier)
#   copy_for(identifier).compiled_content(snapshot: :last)
# end

def item_for(identifier)
  @items.find {|i| i.identifier == identifier }.tap do |i|
    raise "Unable to find item: #{identifier}" if i.nil?
  end
end

def checksum(identifier)
  item = item_for("/#{identifier}/")
  if item.binary?
    self.class.item_digests[item.identifier] ||= 
      begin
        digest = Digest::MD5.new
        File.open(item.raw_filename,'r') do |io|
          until io.eof
            data = io.readpartial(2**10)
            digest.update(data)
          end
        end
        digest.hexdigest[0..7]
      end
  else
    self.class.item_digests[item.identifier] ||= Digest::MD5.hexdigest(item.compiled_content)[0..7]
  end
end
  
def versioned_image(name)
  base, ext = name.split('.')
  "/images/#{base}.#{ext}?#{checksum("assets/images/#{base}")}"
end

def versioned_script(name)
  "/javascripts/#{name}.js?#{checksum("assets/javascripts/#{name}")}"
end

def versioned_styles(name)
  "/styles/#{name}.css?#{checksum("assets/styles/#{name}")}"
end
