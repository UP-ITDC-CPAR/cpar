module IssuesHelper
	def preview_or_default_image(media)
      case media.myfile.file.extension #image is name of uploader class
      when 'jpg', 'jpeg', 'png', 'gif' # , 'png', ...
        media.myfile_url
      #when 'doc', 'docx'
      #  '#{RAILS_ROOT}/public/default_image.png'
      #when 'xls', 'xlsx'
      #  '#{RAILS_ROOT}/public/default_image.png'
      #when 'pdf'
      #  '#{RAILS_ROOT}/public/default_image.png'
      else
        '#{RAILS_ROOT}/public/uploads/issue_attachment/myfile/2/test.gif'
      end
  end
end
