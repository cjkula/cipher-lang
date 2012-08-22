// debugging helper routines

function inspect(obj){
	var type, out, i;
	if(!obj) {
		return 'null';
	}
	type = typeof(obj);
	if(type=='string'){
		out = "\"" + obj.replace(/\\/g,'\\\\').replace(/\"/g,'\\\"') +"\"";
	}else if(obj instanceof Array){
		out = "[";
		for(i=0;i<obj.length;i++){
			out += inspect(obj[i]);
			if(i<obj.length-1){ out += ", " }
		}
		out += "]";
	}else{
		try{
			out = obj.toString();
		}catch(e){
			out = "<" + type + ">";
		}
	}
	return out;
}

function dump(obj, label){
	var out;
	out = inspect(obj) + " % ";
	if(label){
		out = label.toString() + ": " + out;
	}
	alert('% '+out);
}
