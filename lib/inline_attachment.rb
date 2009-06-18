TMail::HeaderField::FNAME_TO_CLASS.delete('content-id')
CID_NAME = 'Content-Id'

module ActionMailer
  module PartContainer
    # Add an inline attachment to a multipart message. 
    def inline_attachment(params, &block)
      params = { :content_type => params } if String === params
      params = { :disposition => "inline",
                 :transfer_encoding => "base64" }.merge(params)
      params[:headers] ||= {}
      params[:headers][CID_NAME] = params[:cid]
      part(params, &block)
    end
  end

  class Base
    private
        
      def create_mail_with_inline_attachment
        # sniff out inline html parts with inline images and wrap them up in a
        # multipart/related mime part
        got_inlines = false
        related_parts = []
        for_deletion = []
        @parts.each_with_index do |p,i|
          if p.content_disposition == 'inline' && p.content_type =~ %r{^image/}i && p.headers[CID_NAME]
            for_deletion << i
            related_parts << p
            got_inlines = true
          end

          if got_inlines && p.content_type =~ %r{text/html}i
            @parts[i] = ActionMailer::Part.new( :content_type => "multipart/related" )
            @parts[i].parts << p
            related_parts.each do |rp|
              @parts[i].parts << rp
            end
            got_inlines = false
            related_parts = []
          end
        end
        for_deletion.sort{|a,b|b<=>a}.each {|i|@parts.delete_at(i)}
        create_mail_without_inline_attachment
      end
      alias_method_chain :create_mail, :inline_attachment
  end
end

module ActionView
  module Helpers #:nodoc:
    module AssetTagHelper
      def path_to_image_with_inline_attachment(source)
        @part_container ||= @controller
        if @part_container.is_a?(ActionMailer::Base) or @part_container.is_a?(ActionMailer::Part)
          if source =~ %r{file://} 
            # Handle attached files from the local filesystem.  Should sandbox this somehow.
            file_path = source.sub(%r{file://}, '')
          else
            # Public image files
            file_path = "#{RAILS_ROOT}/public#{path_to_image_without_inline_attachment(source).split('?').first}"
          end
            
          if File.exists?(file_path)
            basename  = File.basename(file_path)
            ext       = basename.split('.').last
            cid       = Time.now.to_f.to_s + "#{basename}@inline_attachment"

            File.open(file_path, 'rb') do |file|
              @part_container.inline_attachment(:content_type => "image/#{ext}",
                                            :body         => file.read,
                                            :filename     => basename,
                                            :cid          => "<#{cid}>",
                                            :disposition  => "inline")
            end

            return "cid:#{cid}"
          end
        end
        return path_to_image_without_inline_attachment(source)
      end
      alias_method_chain :path_to_image, :inline_attachment
    end
  end
end
