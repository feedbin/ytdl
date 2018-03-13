from __future__ import unicode_literals
from flask import Flask
from flask import request
import youtube_dl
import json

app = Flask(__name__)

@app.route('/info')
def info():
    ydl_opts = {
        'format': '22/18',
        'simulate': True,
        'quiet': True,
        'forceurl': True,
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(request.args.get('video'), download = False)
        return json.dumps(info)

