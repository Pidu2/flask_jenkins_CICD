from flask import Flask
app = Flask(__name__)


def randy(fr, to):
    import random
    return random.randint(fr, to)


@app.route('/')
def hello():
    return 'Hello World!'


@app.route('/cc/<text>')
def cc(text):
    return str(len(text)) + " characters!"


@app.route('/random/<fr>/<to>')
def random(fr, to):
    try:
        return str(randy(int(fr), int(to)))
    except ValueError:
        return "ERROR"

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8888)
