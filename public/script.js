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
		secondsRemainForDisplay--;
		timeoutInstance = setTimeout(flashCleaner, 1000);
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

		hours = (hours < 10) ? "0" + hours : hours;
		minutes = (minutes < 10) ? "0" + minutes : minutes;
		seconds = (seconds < 10) ? "0" + seconds : seconds;

		document.getElementById(divId).textContent = hours + ":" + minutes + ":" + seconds;
	}, 1000);
}

document.getElementById('superhigh').addEventListener('click', function() {
	fetch('/superhigh').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('high').addEventListener('click', function() {
	fetch('/high').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('medium').addEventListener('click', function() {
	fetch('/medium').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('low').addEventListener('click', function() {
	fetch('/low').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('mute').addEventListener('click', function() {
	fetch('/mute').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('no-waves').addEventListener('click', function() {
	fetch('/no-waves').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('no-waves-two').addEventListener('click', function() {
	fetch('/no-waves-two').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('enable-waves').addEventListener('click', function() {
	fetch('/enable-waves').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('skip-track-now').addEventListener('click', function() {
	fetch('/skip-track-now').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('spotify').addEventListener('click', function() {
	fetch('/spotify').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('spotify-reboot').addEventListener('click', function() {
	fetch('/spotify-reboot').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

document.getElementById('techno').addEventListener('click', function() {
	fetch('/techno').then(r => r.text()).then(d => success(d)).catch(e => failure(e));
});

function formatTime(minutes, seconds) {
	const s = (seconds < 10) ? "0" + seconds : seconds;
	return `${minutes}m ${s}s`;
}

let lastTrackText = '';
let lastMetaText = '';

function updateMarquee(trackContainer, trackSpan) {
	if (!trackContainer || !trackSpan) return;

	// Measure overflow
	const needsMarquee = trackSpan.scrollWidth > trackContainer.clientWidth + 1;

	const hadMarquee = trackContainer.classList.contains('marquee');
	if (needsMarquee) {
		trackContainer.classList.add('marquee');

		// If we just enabled it, force a restart (iOS WebKit often needs this)
		if (!hadMarquee) {
			trackSpan.style.webkitAnimation = 'none';
			trackSpan.style.animation = 'none';
			// force reflow
			trackSpan.offsetHeight;
			trackSpan.style.webkitAnimation = '';
			trackSpan.style.animation = '';
		}
	} else {
		trackContainer.classList.remove('marquee');
	}
}

async function refreshNowPlaying() {
	const trackContainer = document.getElementById('np-track');
	const trackSpan = trackContainer ? trackContainer.querySelector('.np-track-text') : null;
	const metaEl = document.getElementById('np-meta');

	try {
		const res = await fetch('/now-playing', { cache: 'no-store' });
		if (!res.ok) throw new Error(`HTTP ${res.status}`);

		const data = await res.json();

		const full = data.track || '';
		const name = full.split('/').pop() || full;

		const trackText = `Now ${data.status || ''}: ${name}`
		const metaText = `Track position: ${formatTime(data?.time?.minutes ?? 0, data?.time?.seconds ?? 0)}`;

		// Update track text only if changed (prevents iOS “stuck” behavior)
		if (trackSpan) {
			if (trackText !== lastTrackText) {
				trackSpan.textContent = trackText;
				lastTrackText = trackText;
				// defer measurement until layout settles
				requestAnimationFrame(() => updateMarquee(trackContainer, trackSpan));
			} else {
				// still re-check on resize/layout changes
				updateMarquee(trackContainer, trackSpan);
			}
		} else if (trackContainer) {
			// fallback if HTML wasn't updated yet
			if (trackText !== lastTrackText) {
				trackContainer.textContent = trackText;
				lastTrackText = trackText;
			}
		}

		if (metaEl && metaText !== lastMetaText) {
			metaEl.textContent = metaText;
			lastMetaText = metaText;
		}
	} catch (e) {
		const fallbackTrack = 'Now Playing: (unavailable)';

		if (trackSpan) {
			if (fallbackTrack !== lastTrackText) {
				trackSpan.textContent = fallbackTrack;
				lastTrackText = fallbackTrack;
				requestAnimationFrame(() => updateMarquee(trackContainer, trackSpan));
			}
		} else if (trackContainer) {
			if (fallbackTrack !== lastTrackText) {
				trackContainer.textContent = fallbackTrack;
				lastTrackText = fallbackTrack;
			}
		}

		if (metaEl && lastMetaText !== '') {
			metaEl.textContent = '';
			lastMetaText = '';
		}

		console.log('now-playing refresh failed:', e);
	}
}

refreshNowPlaying();
setInterval(refreshNowPlaying, 2000);

startClock('clock');

window.addEventListener('resize', () => {
	const trackContainer = document.getElementById('np-track');
	const trackSpan = trackContainer ? trackContainer.querySelector('.np-track-text') : null;
	updateMarquee(trackContainer, trackSpan);
});

