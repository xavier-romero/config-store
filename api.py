from flask import Flask, jsonify, request
from simple_storage import SimpleStorage


def create_app():
    app = Flask(__name__)
    app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
    return app


ss = SimpleStorage()
app = create_app()


@app.route('/<string:context>', methods=['POST'])
def set(context: str):
    data = request.get_json(silent=True)
    if (not data) or (not isinstance(data, dict)):
        return {}

    for k, v in data.items():
        ss.set(k, v, context)

    return jsonify(data)


@app.route('/', methods=['POST'])
def set_default():
    return set(0)


@app.route('/<string:context>/<string:k>', methods=['GET'])
def get(context: str, k: str):
    v = ss.get(k, context)
    return jsonify({k: v})


@app.route('/<string:k>', methods=['GET'])
def get_default(k: str):
    return get(0, k)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=50061)
