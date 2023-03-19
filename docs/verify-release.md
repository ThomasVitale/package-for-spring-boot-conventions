# Verifying the Knative Serving Package Release

This package is published as an OCI artifact, signed with Sigstore [Cosign](https://docs.sigstore.dev/cosign/overview), and associated with a [SLSA Provenance](https://slsa.dev/provenance) attestation.

Using `cosign`, you can display the supply chain security related artifacts for the `ghcr.io/kadras-io/package-for-spring-boot-conventions` images. Use the specific digest you'd like to verify.

```shell
cosign tree ghcr.io/kadras-io/package-for-spring-boot-conventions
```

The result:

```shell
📦 Supply Chain Security Related artifacts for an image: ghcr.io/kadras-io/package-for-spring-boot-conventions
└── 💾 Attestations for an image tag: ghcr.io/kadras-io/package-for-spring-boot-conventions:sha256-751dd0b3bcc76e2dd3d4b6152b45af790db1959661bf54e1fd36d82d89b0b6be.att
   └── 🍒 sha256:d1a5c678a5189904f7fe2cb69d3890f9565d0f2bad56c693008dc5b7a61c36ca
└── 🔐 Signatures for an image tag: ghcr.io/kadras-io/package-for-spring-boot-conventions:sha256-751dd0b3bcc76e2dd3d4b6152b45af790db1959661bf54e1fd36d82d89b0b6be.sig
   └── 🍒 sha256:d5c3d876dd1f90dc2771e7c08a1cef843cb3b90cdb55da4f143ce684c7fb9bf2
```

You can verify the signature and its claims:

```shell
cosign verify \
   --certificate-identity-regexp https://github.com/kadras-io \
   --certificate-oidc-issuer https://token.actions.githubusercontent.com \
   ghcr.io/kadras-io/package-for-spring-boot-conventions | jq
```

You can also verify the SLSA Provenance attestation associated with the image.

```shell
cosign verify-attestation --type slsaprovenance \
   --certificate-identity-regexp https://github.com/slsa-framework \
   --certificate-oidc-issuer https://token.actions.githubusercontent.com \
   ghcr.io/kadras-io/package-for-spring-boot-conventions | jq .payload -r | base64 --decode | jq
```
