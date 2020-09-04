var Item = {


	send_post: function(path, id) {

	  // debugger
	  const form = document.createElement('form');
	  form.method = "post";
	  form.action = path;
      const hiddenField = document.createElement('input');
      hiddenField.type = 'hidden';
      hiddenField.name = 'item_id';
      hiddenField.value = id;
      form.appendChild(hiddenField);
	  document.body.appendChild(form);
	  form.submit();
	  //window.location.replace( path +"?id=" + id)
	},



	getConnectionActivityStats: function(post_path,item_id){
		setTimeout(function() {document.getElementById('text').innerHTML = "Payment Started";}, 500);
		setTimeout(function() {document.getElementById('text').innerHTML = "Payment Processing";}, 3000);
		setTimeout(function() {document.getElementById('text').innerHTML = "Payment Successfully Completed";
							   document.getElementById('text').style.border = 'thin solid green';
							   document.getElementById("text").style.borderRadius = "25px"; }, 7000);

			
		setTimeout(function() { 
			Item.send_post(post_path, item_id );
		},9000);
	}

}

