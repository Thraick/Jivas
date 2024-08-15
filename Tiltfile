# -*- mode: Python -*

# import restart_process extension
# load('ext://restart_process', 'docker_build_with_restart')

# Define how to build the Docker image for the FastAPI application
congrats = "🎉 Congrats, you ran a live_update! 🎉"
#docker_build_with_restart(
docker_build(
    "jivas", 
    context=".", 
    dockerfile="configs/jivas.Dockerfile",
    ignore=["**/__jac_gen__/", "**/.mypy_cache/", "**/*.test.jac", "**/.pytest_cache", "__pycache__", "**/tests/"],
    entrypoint=["sh", "-c", "./start.sh"],
    live_update=[
        sync("jac2/", "/app/"),
        run("echo '%s'" % congrats, trigger="jac2/"),
        run("cd /app && pip install --no-cache-dir --ignore-installed -r requirements.txt", trigger="./jac2/requirements.txt"),
        run("jac clean", trigger="jac2/"),
        run("./restart.sh")
    ],
)

# Load Kubernetes manifests
k8s_yaml("configs/namespace.yaml")
k8s_yaml("configs/mongodb-statefulset.yaml")
k8s_yaml("configs/mongodb-init-job.yaml")
k8s_yaml("configs/redis-deployment.yaml")
k8s_yaml("configs/elastic-deployment.yaml")
k8s_yaml("configs/jivas-deployment.yaml")

# Wait for MongoDB ReplicaSet initialization
k8s_resource("mongo-init", resource_deps=["mongodb"])

# Attach the FastAPI service to Tilt
k8s_resource("jivas", port_forwards=8000)
 