
let secondsRemainForDisplay = 0;
let timeoutInstance = null;

function success(text) {
	console.log(text);
	document.getElementById('info').innerText = 'Success';
	flashCleaner(3);
}

function failure(text) {
	console.log(text);	
	document.getElementById('info').innerText = 'Error, check console';
	flashCleaner(3);
}

function flashCleaner(seconds) {
	clearTimeout(timeoutInstance);
	if (seconds) {
		secondsRemainForDisplay = seconds;
	}
	if (secondsRemainForDisplay) {
		secondsRemainForDisplay --;
		timeoutInstance = setTimeout(flashCleaner,1000);
	} else {
		document.getElementById('info').innerText = '';
		timeoutInstance = null;
	}
}

function startClock(divId) {
    setInterval(function() {
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        
        // Add leading zeros if necessary
        hours = (hours < 10) ? "0" + hours : hours;
        minutes = (minutes < 10) ? "0" + minutes : minutes;
        seconds = (seconds < 10) ? "0" + seconds : seconds;
        
        // Set the text content of the div
        document.getElementById(divId).textContent = hours + ":" + minutes + ":" + seconds;
    }, 1000);  // Update every second
}


document.getElementById('superhigh').addEventListener('click', function() {
    fetch('/superhigh').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('high').addEventListener('click', function() {
    fetch('/high').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('medium').addEventListener('click', function() {
    fetch('/medium').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('low').addEventListener('click', function() {
    fetch('/low').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('mute').addEventListener('click', function() {
    fetch('/mute').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('no-waves').addEventListener('click', function() {
    fetch('/no-waves').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('no-waves-two').addEventListener('click', function() {
    fetch('/no-waves-two').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('enable-waves').addEventListener('click', function() {
    fetch('/enable-waves').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('skip-track-now').addEventListener('click', function() {
    fetch('/skip-track-now').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });



document.getElementById('spotify').addEventListener('click', function() {
    fetch('/spotify').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });

document.getElementById('spotify-reboot').addEventListener('click', function() {
    fetch('/spotify-reboot').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });



document.getElementById('techno').addEventListener('click', function() {
    fetch('/techno').then(response => response.text()).then(data => success(data)).catch(e => failure(e)); });











startClock('clock')
