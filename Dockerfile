FROM registry.redhat.io/openshift4/ose-operator-registry:v4.3.2 AS builder
COPY filtered-manifests manifests
RUN /bin/initializer -o ./bundles.db

FROM registry.access.redhat.com/ubi7/ubi
COPY --from=builder /registry/bundles.db /bundles.db
COPY --from=builder /usr/bin/registry-server /registry-server
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
EXPOSE 50051
ENTRYPOINT ["/registry-server"]
CMD ["--database", "bundles.db"]
