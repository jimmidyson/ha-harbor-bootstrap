{
  description = "Useful flakes for golang and Kubernetes projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system}; rec {
        packages = rec {
          helm-list-images = buildGo123Module rec {
            pname = "helm-list-images";
            version = "0.12.0";

            src = fetchFromGitHub {
              owner = "d2iq-labs";
              repo = "helm-list-images";
              rev = "v${version}";
              hash = "sha256-9mtlRM8kUyIOCST/5ReKjRAj9KnVFKRWHRc/ExIo9wU=";
            };
            doCheck = false;
            vendorHash = "sha256-Jm+dT1AGqHwXjTer9zNESs/8LcWPIKNmG+aeS3jkEs0=";
            ldflags = let t = "main"; in [
              "-s"
              "-w"
              "-X ${t}.BuildDate=19700101-00:00:00"
              "-X ${t}.GitCommit=v${version}"
              "-X ${t}.Version=v${version}"
            ];

            postPatch = ''
              sed -i '/^hooks:/,+2 d' plugin.yaml
              sed -i 's#command: $HELM_PLUGIN_DIR/bin/helm-list-images#command: "$HELM_PLUGIN_DIR/helm-list-images"#' plugin.yaml
            '';

            postInstall = ''
              install -dm755 $out/${pname}
              mv $out/bin/* $out/${pname}/
              install -m644 -Dt $out/${pname} plugin.yaml
            '';
          };

          helm-with-plugins = wrapHelm kubernetes-helm {
            plugins = [
              helm-list-images
            ];
          };
        };

        formatter = alejandra;
      }
    );
}
