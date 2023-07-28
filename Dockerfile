FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild

# Add timeouts so we don't have to wait a full 5 minutes for the deployer to timeout
ENV WAIT_FOR_READY_TIMEOUT 100
ENV TESTER_TIMEOUT 100