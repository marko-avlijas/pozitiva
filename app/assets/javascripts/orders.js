// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){    
  $('#order_note').maxlength({   
    events: [], // Array of events to be triggerd    
    maxCharacters: 500, // Characters limit   
    status: true, // True to show status indicator bewlow the element    
    statusClass: "status", // The class on the status div  
    statusText: "character left", // The status text  
    notificationClass: "alert alert-danger",	// Will be added when maxlength is reached  
    showAlert: false, // True to show a regular alert message    
    alertText: "You have typed too many characters.", // Text in alert message   
    slider: false // True Use counter slider    
  }); 
});