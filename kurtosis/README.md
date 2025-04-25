# Kurtosis package
Config Store provides a simple kurtosis package allowing to save and retrieve arbitrary data.

# Example usage
```python
config_store = import_module("github.com/xavier-romero/config-store/kurtosis/main.star")

def run(plan, args={}):
    # Required to initialize the config store
    config_store.init(plan)

    # Set any key-value pair
    config_store.set(plan, "username1", "john")
    config_store.set(plan, "username2", "james")
    config_store.set(plan, "amount", 1)
    config_store.set(plan, 25, 3)
    config_store.set(plan, 100, "hundred")

    # Retrieve any key-value pair by its key
    username1 = config_store.get(plan, "username1")
    username2 = config_store.get(plan, "username2")
    amount = config_store.get(plan, "amount")
    s25 = config_store.get(plan, 25)
    s100 = config_store.get(plan, 100)

    # Retrieve non existing keys
    # WARN: This will return a fixed string: _NOT_FOUND_
    non_existing1 = config_store.get(plan, "non_existing1")
    non_existing2 = config_store.get(plan, "non_existing2")

    # Put all the results together in a dictionary just for printing easily
    results = {
        "username1": username1,
        "username2": username2,
        "amount": amount,
        25: s25,
        100: s100,
        "non_existing1": non_existing1,
        "non_existing2": non_existing2,
    }

    # Print the retrieved results
    plan.print("Got results: {}".format(results))

    # Get all available keys at once
    data = config_store.dump(plan)
    plan.print("Dumped data: {}".format(data))
```

# Contexts
Namespaces(contexts) can be used to isolate configs, etc, so same key can be used in different contexts.

If not specified, default context is: 0

```python
    config_store.set(plan, "username", "john") # it's the same than using context c=0
    config_store.set(plan, "username", "frank", c=1)
    config_store.set(plan, "username", "james", c="another_context")
    config_store.set(plan, "username", "marc", c="yet_another_context")

    config_store.get(plan, "username") # it's the same than using context c=0
    config_store.get(plan, "username", c=1)
    config_store.get(plan, "username", c="another_context")
    config_store.get(plan, "username", c="yet_another_context")
```

# Save whatever
You can also store and retrieve complex data, as long as it's JSON serializable

```python
    # Store a whole dictionary
    sample_dict = {
        "username": "john",
        "age": 25,
        "genre": "male",
        "address": {
            "street": "123 Main St",
            "city": "New York",
            "state": "NY",
            "zip": "10001",
        },
        "hobbies": ["reading", "gaming", "hiking"],
        "is_active": True,
        "balance": 100.50,
        "friends": [
            {"name": "Alice", "age": 30, "is_active": True},
            {"name": "Bob", "age": 28, "is_active": False},
        ],
    }
    config_store.set(plan, "sample_dict", sample_dict)
    
    # Retrieve and print the whole dictionary
    retrieved_dict = config_store.get(plan, "sample_dict")
    plan.print("Got dictionary: {}".format(retrieved_dict))

```

# Subkeys
You can also retrieve specific subkeys

```python
    # Retrieve specific subkeys from the dictionary
    street = config_store.get(plan, "sample_dict.address.street")
    plan.print("Got street: {}".format(street))
```

# Shared data
As the purpose is to facilitate passing configuration parameters between different .star files as well as between different packages, you can safely include this code in multiple places:

```python
config_store = import_module("github.com/xavier-romero/config-store/kurtosis/main.star")

def whatever(plan):
    # Required to initialize the config store
    config_store.init(plan)
```

Only the first call to ```init()``` will create the service, as the service is unique across the kurtosis enclave, so all data posted will be shared everywhere.

You can use contexts if you need to have different sets of data, with potentially overlapping keys.

# User inteface
Once your kurtosis package is running and as long as ```init()``` has been already executed, you can see all your data by pointing your browser to:

- [http://127.0.0.1:5678](http://127.0.0.1:5678)

Please see [../README.md#usage](../README.md#usage) for detailed examples on how to POST and GET data.
