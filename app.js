const express = require('express');
const { exec } = require('child_process');
const app = express();
const path = require('path');
app.set('view engine', 'ejs');

console.log('gizim', path.join(__dirname, 'public'));

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res) {
    res.render('index');
});

app.get('/superhigh', function(req, res) {
    exec('bash /home/giz/media_station/superhigh.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/high', function(req, res) {
    exec('bash /home/giz/media_station/high.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/medium', function(req, res) {
    exec('bash /home/giz/media_station/medium.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/low', function(req, res) {
    exec('bash /home/giz/media_station/low.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/no-waves', function(req, res) {
    exec('bash /home/giz/media_station/no-waves.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/no-waves-two', function(req, res) {
    exec('bash /home/giz/media_station/no-waves-two.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/enable-waves', function(req, res) {
    exec('bash /home/giz/media_station/enable-waves.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/skip-track-now', function(req, res) {
    exec('bash /home/giz/media_station/skip-track-now.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/mute', function(req, res) {
    exec('bash /home/giz/media_station/mute.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/spotify', function(req, res) {
    exec('bash /home/giz/media_station/spotify.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/spotify-reboot', function(req, res) {
    exec('bash /home/giz/media_station/spotify-reboot.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/techno', function(req, res) {
    exec('bash /home/giz/media_station/techno.sh', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send(stdout);
    });
});

app.get('/now-playing', function(req, res) {
    exec('/home/giz/media_station/get_current_track.sh json', (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return res.status(500).json({ error: 'exec_failed' });
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
        }

        try {
            const data = JSON.parse(stdout);
            res.json(data);
        } catch (e) {
            console.log(`parse error: ${e.message}`);
            res.status(500).json({ error: 'bad_json', raw: stdout });
        }
    });
});

app.listen(3000, function() {
    console.log('App listening on port 3000!');
});

