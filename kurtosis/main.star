DOCKER_IMAGE = "xavierromero/config-store:latest"
EXPOSED_PORT = 8000
SERVICE_NAME = "config-store"

def run(plan, args={}):

    ports = {
        SERVICE_NAME: PortSpec(
            EXPOSED_PORT, application_protocol="http", wait="30s"
        ),
    }

    plan.add_service(
        name=SERVICE_NAME,
        config=ServiceConfig(
            image=DOCKER_IMAGE,
            ports=ports,
            public_ports=ports,
            env_vars={"PORT": str(EXPOSED_PORT)},
        ),
    )

