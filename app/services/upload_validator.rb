class UploadValidator
  
  UPLOAD_CONTENT_TYPES_WHITELIST = %w(application/pdf)
  UPLOAD_MAX_FILE_SIZE = 4.megabytes
  
  def initialize(model, attachment_attr, uploaded_attachment)
    @model = model
    @attachment_attr = attachment_attr
    @uploaded_attachment = uploaded_attachment
  end
  
  def valid?
    valid_content_type? && valid_size?
  end
   
  def valid_content_type?
    if UPLOAD_CONTENT_TYPES_WHITELIST.include?(@uploaded_attachment.content_type)
      true
    else
      @model.errors.add(@attachment_attr, "Dozvoljen je samo PDF dokument")
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