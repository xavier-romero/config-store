import json


class SimpleStorage():
    class Context():
        def __init__(self, id):
            self.id = id
            self.keys = {}
            try:
                with open(f"context-{self.id}.json", "r") as f:
                    self.keys = json.load(f)
            except Exception:
                pass

        def set(self, k, v):
            print(f"setting {k} to {v} for {self.id}")
            self.keys[k] = v
            self.save()

        def get(self, k):
            return self.keys.get(k)

        def save(self):
            print(f"saving {self.keys} for {self.id}")
            with open(f"context-{self.id}.json", "w") as f:
                json.dump(self.keys, f)

    def __init__(self):
        print("INITIALIZING SSTORAGE")
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
