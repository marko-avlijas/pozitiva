class UploadValidator
  
  UPLOAD_MAX_FILE_SIZE = 4.megabytes
  PDF_CONTENT_TYPE_WHITELIST = %w(application/pdf)
  IMAGE_CONTENT_TYPE_WHITELIST = %w(image/png image/jpeg image/gif)
  
  def initialize(model, attachment_attr, uploaded_attachment, upload_type)
    @model = model
    @attachment_attr = attachment_attr
    @uploaded_attachment = uploaded_attachment
  end
  
  def valid?
    valid_content_type? && valid_size?
  end
   
  def valid_content_type_for?(content_type)
    if content_type == :pdf
      whitelist = PDF_CONTENT_TYPE_WHITELIST
    elsif content_type == :image
      whitelist = IMAGE_CONTENT_TYPE_WHITELIST
    end
    if whitelist.include?(@uploaded_attachment.content_type)
      true
    else
      @model.errors.add(@attachment_attr, "Dozvoljeni formati: #{CONTENT_TYPE_WHITELIST}")
      false
    end
  end
  
  def valid_size?
    if @uploaded_attachment.tempfile.try(:size).to_i <= UPLOAD_MAX_FILE_SIZE
      true
    else
      @model.errors.add(@attachment_attr, "Maksimalna dozvoljena veličina datoteke je #{number_to_human_size(UPLOAD_MAX_FILE_SIZE)}")
      false
    end
  end
  
end