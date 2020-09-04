function validateFiles(inputFile) {
  var maxExceededMessage = "This file exceeds the maximum allowed file size (5 MB)";
  var extErrorMessage = "Only image file with extension: .jpg, .jpeg, .gif or .png is allowed";
  var allowedExtension = ["jpg", "jpeg", "gif", "png"];

  var extName;
  var maxFileSize = $(inputFile).data('max-file-size');
  var sizeExceeded = false;
  var extError = false;

  $.each(inputFile.files, function() {
    console.log(this.size)
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


function newCategory(that) {
    if (that.value == 0) {
        document.getElementById("newCategoryDiv").style.display = "block";
    } else {
        document.getElementById("newCategoryDiv").style.display = "none";
    }
}

// function setValue(that){
//     if (that.value == 1) {
//         console.log("came to 1")
//         //document.getElementById("newCategoryDiv").style.display = "block";
//         that.value = 1;
//     } 
//     else if (that.value == 2) {
//         console.log("came to 2")
//         document.getElementById("profile_feed_id").value = //.style.display = "block";
//         //that.value = 2;
//     } 
//     else if (that.value == 3) {
//         console.log("came to 3")
//         //document.getElementById("newCategoryDiv").style.display = "block";
//         that.value = 3;
//     }
// }

// function copyToClipboard(element) {
//   var $temp = $("<input>");
//   $("body").append($temp);
//   $temp.val($(element).text()).select();
//   document.execCommand("copy");
//   $temp.remove();
// }

// function numberdisplay(that) {
//     if (that.value == 0) {
//         document.getElementById("copy").style.display = "inline";
//     } else {
//         document.getElementById("copy").style.display = "none";
//     }
// }

// function showDetails() {
//   var x = document.getElementById("details");
//   if (x.style.display === "none") {
//     x.style.display = "block";
//   } else {
//     x.style.display = "none";
//   }
// }

// function show_details() {
//     $("#show_details").on('click', function() {
//         $(this).next("#details").toggle();
//     });
// }