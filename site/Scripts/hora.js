

function clock(){
    var currentTime = new Date()
    var hours = currentTime.getHours()
    var minutes = currentTime.getMinutes()
    var seconds = currentTime.getSeconds()

    if (minutes < 10)
	minutes = "0" + minutes;
    if (seconds < 10)
	seconds = "0" + seconds;
    $('#horacont').text(hours + ":" +  minutes + ":" +  seconds);

    if (hours > 8 && hours < 13)
	$('#turnocont').text("mañana");
    else if (hours >=13 && hours < 17 )
	$('#turnocont').text("tarde");
    else
	$('#turnocont').text("noche");


    setTimeout('clock()',1000);
}

$(document).on('ready',clock());

