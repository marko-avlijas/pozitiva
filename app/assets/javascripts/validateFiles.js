// source: http://stevenyue.com/2013/04/03/validate-attachment-file-size-and-type-in-rails/
// use:    <%= f.file_field :attachment, onchange: "validateFiles(this);", data: {max_file_size: 4.megabytes} %>

function validateFiles(inputFile) {
  var maxExceededMessage = "This file exceeds the maximum allowed file size (4 MB)";
  // var extErrorMessage = "Only image file with extension: .jpg, .jpeg, .gif or .png is allowed";
  // var allowedExtension = ["jpg", "jpeg", "gif", "png"];
  var extErrorMessage = "Only PDF file is allowed";
  var allowedExtension = ["pdf"];
 
  var extName;
  var maxFileSize = $(inputFile).data('max-file-size');
  var sizeExceeded = false;
  var extError = false;
 
  $.each(inputFile.files, function() {
    if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {sizeExceeded=true;};
    extName = this.name.split('.').pop();
    if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
  });
  if (sizeExceeded) {
    window.alert(maxExceededMessage);
    $(inputFile).val('');
  };
 
  if (extError) {
    window.alert(extErrorMessage);
    $(inputFile).val('');
  };
}