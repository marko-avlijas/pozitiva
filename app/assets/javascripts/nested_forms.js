// inspired by http://davidlesches.com/blog/rails-nested-forms-using-jquery-and-simpleform
// and http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html

$(document).ready(function() {
  
  // searching for nested resource hidden field "id":
  // <input id="offer_offer_items_attributes_0_id" name="offer[offer_items_attributes][0][id]" type="hidden" >
  // to make _destroy field:
  // <input id="offer_offer_items_attributes_0__destroy" name="offer[offer_items_attributes][0][_destroy]" type="hidden" value="1">
  
  // from each "id" of associated model add "_destroy" field:
  $('.duplicatable_nested_form').find('[name$="[id]"]:hidden').each(function() {
    var new_destroy = $(this).clone();
    
    var oldId = new_destroy.attr('id');
    var newId = oldId.replace(new RegExp(/id/), "_destroy");
    new_destroy.attr('id', newId);
    
    var oldName = new_destroy.attr('name');
    var newName = oldName.replace(new RegExp(/id/), "_destroy");
    new_destroy.attr('name', newName);
    
    new_destroy.val('0');
    new_destroy.insertAfter($(this));
  });
  
  
  $('.duplicate_nested_form').click(function(e) {
    e.preventDefault();
    var nestedForms = $('.' + $(this).data('fields'));
    var formsOnPage = nestedForms.length;
    var lastNestedForm = nestedForms.last();
    var newNestedForm = lastNestedForm.clone().hide();
    
    newNestedForm.find('label').each(function() {
      var oldLabel = $(this).attr('for');
      if (!(typeof oldLabel === "undefined")) {
       var newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_" + formsOnPage + "_");
       $(this).attr('for', newLabel);
      }
    });
    
    newNestedForm.find('select, input, textarea').each(function() {
      var oldId = $(this).attr('id');
      var newId = oldId.replace(new RegExp(/_[0-9]+_/), "_" + formsOnPage + "_");
      $(this).attr('id', newId);
      var oldName = $(this).attr('name');
      var newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[" + formsOnPage + "]");
      $(this).attr('name', newName);
      $(this).val("");
    });
    newNestedForm.find('[name$="[_destroy]"]:hidden').val("0");
    
    newNestedForm.insertAfter(lastNestedForm);
    
    newNestedForm.find(".packaging-details").hide();
    newNestedForm.find('div.row:first').show();
    newNestedForm.slideDown('slow');
    
    // re-initialize datetimepicker
    $('.datetimepicker').datetimepicker({language: "hr"});
    zebra();
    return false;
  });
  
  // $(".remove_nested_form:first").remove(); // if at least one has to stay on form
}); // end of $(document).ready

$(document).on('click', '.remove_nested_form', function(e) {
  e.preventDefault();
  var nestedForm = $(this).closest('.' + $(this).data('fields'));
  nestedForm.find('[name$="[_destroy]"]:hidden').val("1");
  nestedForm.slideUp('slow');
  return false;
});