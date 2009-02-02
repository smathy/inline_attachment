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
    alias_method :ia_original_create_mail, :create_mail
    def create_mail
      # sniff out inline html parts with inline images and wrap them up in a
      # multipart/related mime part
      got_inlines = false
      related_parts = []
      for_deletion = []
      @parts.each_with_index do |p,i|
        logger.debug "Considering #{i}"
        if p.content_disposition == 'inline' && p.content_type =~ %r{^image/}i && p.headers[CID_NAME]
          logger.debug "Just adding [#{i}] to the list\n#{p.filename}"
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
      ia_original_create_mail
    end
  end
end

module ActionView
  module Helpers #:nodoc:
    module AssetTagHelper
      alias_method :ia_original_path_to_image, :path_to_image
      def path_to_image(source)
        @part_container ||= @controller
        if @part_container.is_a?(ActionMailer::Base) or @part_container.is_a?(ActionMailer::Part)
          file_path = "#{RAILS_ROOT}/public#{ia_original_path_to_image(source).split('?').first}"

          if File.exists?(file_path)
            basename  = File.basename(file_path)
            ext       = basename.split('.').last
            cid       = Time.now.to_f.to_s + "#{basename}@inline_attachment"
            file      = File.open(file_path, 'rb')

            @part_container.inline_attachment(:content_type => "image/#{ext}",
                                          :body         => file.read,
                                          :filename     => basename,
                                          :cid          => "<#{cid}>",
                                          :disposition  => "inline")
            
            return "cid:#{cid}"
          end
        end
        return ia_original_path_to_image(source)
      end
    end
  end
end
