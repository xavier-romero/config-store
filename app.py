import sys
import json
import threading
from flask import Flask, request, Response


class SimpleStorage():
    class Context():
        def __init__(self, id):
            self.id = id
            self.fname = f"context-{self.id}.json"
            self.lock = threading.Lock()

        def set(self, k, v):
            print(f"INFO: Setting {k} to {v} for c:{self.id}")
            with self.lock:
                data = self.load()
                if data.get(k) == v:
                    print(f"WARN: {k} is already set to {v} for c:{self.id}")
                    return
                else:
                    data[k] = v
                    self.save(data)

        def get(self, k):
            print(f"INFO: Reading {k} for c:{self.id}")
            with self.lock:
                data = self.load()
                return data.get(k)

        def load(self):
            data = {}
            try:
                with open(self.fname, "r") as f:
                    data = json.load(f)
            except Exception:
                print(f"WARN: No file found for c:{self.id}")
            else:
                print(f"INFO: Loaded {data} for c:{self.id}")
            finally:
                assert isinstance(data, dict), \
                    f"ERROR: data is not a dict: {data}"
                return data

        def save(self, data):
            print(f"INFO: Saving {data} for {self.id}")
            with open(self.fname, "w") as f:
                json.dump(data, f, indent=4)

    def __init__(self):
        self.contexts = {
            0: self.Context(0)
        }

    def _context(self, context, create):
        if not self.contexts.get(context):
            if create:
                self.contexts[context] = self.Context(context)
            else:
                return None

        return self.contexts[context]

    def set(self, k, v, c=0):
        context = self._context(c, create=True)
        context.set(k, v)

    def get(self, k, c=0):
        context = self._context(c, create=False)
        if context:
            return context.get(k)
        else:
            return None

    def dump(self, c=0):
        context = self._context(c, create=False)
        data = {}
        if context:
            data = context.load()

        assert isinstance(data, dict), \
            f"ERROR: data is not a dict: {data}"
        return data


def create_app():
    app = Flask(__name__)
    app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
    return app


ss = SimpleStorage()
app = create_app()


def my_jsonify(data):
    # jsonify from Flask only works in debug mode
    return Response(json.dumps(data, indent=4), mimetype='application/json')


@app.route('/<string:context>', methods=['POST'])
def set(context: str):
    data = request.get_json(silent=True)
    if (not data) or (not isinstance(data, dict)):
        return {}

    for k, v in data.items():
        ss.set(k, v, context)

    return my_jsonify(data)


@app.route('/', methods=['POST'])
def set_default():
    return set(0)


@app.route('/<string:context>/<string:k>', methods=['GET'])
def get(context: str, k: str):
    v = ss.get(k, context)
    return my_jsonify({k: v})


@app.route('/<string:k>', methods=['GET'])
def get_default(k: str):
    return get(0, k)


@app.route('/dump/<string:context>', methods=['GET'])
def dump(context: str):
    d = ss.dump(context)
    return my_jsonify(d)


@app.route('/', methods=['GET'])
def dump_default():
    return dump(0)


port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
app.run(host='0.0.0.0', port=port)
