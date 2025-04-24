DOCKER_IMAGE = "xavierromero/config-store:latest"
EXPOSED_PORT = 8000
SERVICE_NAME = "config-store"


def _run(plan):
    ports = {
        SERVICE_NAME: PortSpec(EXPOSED_PORT, application_protocol="http", wait="30s"),
    }

    return plan.add_service(
        name=SERVICE_NAME,
        config=ServiceConfig(
            image=DOCKER_IMAGE,
            ports=ports,
            public_ports=ports,
            env_vars={
                "PORT": str(EXPOSED_PORT),
                "NOT_FOUND_VALUE": "_NOT_FOUND_",
            },
        ),
    )


def _check_service(plan):
    """
    Check if the service is already running.
    """
    services = plan.get_services(description="ConfigStore: Listing services")
    for service in services:
        if service.name == SERVICE_NAME:
            return service

    return _run(plan)


def init(plan):
    _check_service(plan)


def run(plan, args={}):
    pass


def set(plan, k, v, c=0):
    if type(k) == type(1):
        k = "s{}".format(str(k))
        plan.print("ConfigStore: Key is an integer, converting to string: {}".format(k))

    if not (type(k) == type("string")):
        fail("ConfigStore: Key {0} of type {1} must be a string".format(k, type(k)))

    body = {k: v}
    post_request_recipe = PostHttpRequestRecipe(
        port_id=SERVICE_NAME,
        endpoint="/{}".format(c),
        content_type="application/json",
        body=json.encode(body),
        extract={
            "result": ".{}".format(k),
        },
    )

    http_response = plan.request(
        service_name=SERVICE_NAME,
        recipe=post_request_recipe,
        acceptable_codes=[200],
        skip_code_check=False,
        description="ConfigStore: Setting {0} to {1}".format(k, v),
    )


def get(plan, k, c=0):
    if type(k) == type(1):
        k = "s{}".format(str(k))
        plan.print("ConfigStore: Key is an integer, converting to string: {}".format(k))

    if not (type(k) == type("string")):
        fail("ConfigStore: Key {0} of type {1} must be a string".format(k, type(k)))

    get_request_recipe = GetHttpRequestRecipe(
        port_id=SERVICE_NAME,
        endpoint="/{0}/{1}".format(c, k),
        extract={
            "result": ".{}".format(k),
        },
    )

    http_response = plan.request(
        service_name=SERVICE_NAME,
        recipe=get_request_recipe,
        acceptable_codes=[200, 404],
        skip_code_check=False,
        description="ConfigStore: Getting value for {}".format(k),
    )

    if http_response["extract.result"] == "_NOT_FOUND_":
        plan.print("ConfigStore: Key {} not found".format(k))
        return None
    else:
        plan.print(
            "ConfigStore: Key {0} found with value {1}".format(
                k, http_response["extract.result"]
            )
        )
        return http_response["extract.result"]


def dump(plan, c=0):
    get_request_recipe = GetHttpRequestRecipe(
        port_id=SERVICE_NAME,
        endpoint="/dump/{}".format(c),
        extract={
            "result": ".",
        },
    )

    http_response = plan.request(
        service_name=SERVICE_NAME,
        recipe=get_request_recipe,
        acceptable_codes=[200],
        skip_code_check=False,
        description="ConfigStore: Dumping all values",
    )

    return http_response["extract.result"]
