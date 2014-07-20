var id_cajas = ["altas", "inyectado"];
var id_flechas = ["altas_inyectado"];
var vars = ["left", "right", "cont"];
var refreshTime = 1000;
var url = "FetchDBWebService.asmx/FetchData";



$(document).on("ready", function () {
    askServer();
    isOn = true;
    intervalId = setInterval(askServer, refreshTime);
});


// to make click to pause refresh
var intervalId; var isOn;
$(document).on("click", function () {
    if (isOn) {
        clearInterval(intervalId);
        isOn = false;
    }
    else {
        intervalId = setInterval(askServer, refreshTime);
        isOn = true;
    }
});
//end that click to pause thing


function askServer() {
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        url: url,
        success: getAll,
        error: function (o, st, err) {
            console.log(st + err);
        }
    })
}

function getAll(o) {
    var json = JSON.parse(o.d);
    console.log(json);
    for (var i = 0; i < id_cajas.length; i++) {
        getCaja(id_cajas[i], json);
    }
    for (var i = 0; i < id_flechas.length; i++) {
        getFlecha(id_flechas[i], json);
    }

}

function getCaja(id, json) {
    var caja = json[id];

    for (var i = 0; i < vars.length; i++) {
        var v = vars[i];
        $("#" + id + v).text(caja[v]);
        if (v == "right")
            $("#" + id + v).text(caja[v] + "%");
    }

    var lf = $("#" + id + " .lowinfo");

    if (caja.right < 80)
        lf.css({ 'backgroundColor': "rgb(198, 58, 58)" });
    else if (caja.right < 90)
        lf.css({ 'backgroundColor': "rgb(225, 232, 88)" });
    else
        lf.css({ 'backgroundColor': "rgb(99, 184, 85)" });

}

function getFlecha(id, json) {

    var flecha = json[id];
    
    $('#' + id + "_cont").text(flecha);
    $('#' + id).css({ 'backgroundColor': "rgb(99, 184, 85)" });

}