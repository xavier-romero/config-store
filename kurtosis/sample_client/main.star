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

    # Set any key-value pair with a context
    config_store.set(plan, "username", "john")  # it's the same than using context c=0
    config_store.set(plan, "username", "frank", c=1)
    config_store.set(plan, "username", "james", c="another_context")
    config_store.set(plan, "username", "marc", c="yet_another_context")

    # Retrieve any key-value pair by its key and context
    config_store.get(plan, "username")  # it's the same than using context c=0
    config_store.get(plan, "username", c=1)
    config_store.get(plan, "username", c="another_context")
    config_store.get(plan, "username", c="yet_another_context")

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

    # Retrieve specific subkeys from the dictionary
    street = config_store.get(plan, "sample_dict.address.street")
    plan.print("Got street: {}".format(street))
