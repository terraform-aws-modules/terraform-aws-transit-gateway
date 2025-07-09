# Changelog

All notable changes to this project will be documented in this file.

## [2.13.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.12.2...v2.13.0) (2025-01-15)


### Features

* Add support for security group referencing to transit-gateway module ([#133](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/133)) ([26c10f3](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/26c10f34d144554eb965598127f86f87d6bb279a))


### Bug Fixes

* Update CI workflow versions to latest ([#134](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/134)) ([77279c9](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/77279c9d76d7b9978a502cd175173a1a4d7cdecf))

## [2.12.2](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.12.1...v2.12.2) (2024-03-06)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#130](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/130)) ([d3391d6](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/d3391d692ef1de6e8b3ccedfa1bf4aac54b91ca0))

### [2.12.1](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.12.0...v2.12.1) (2023-12-11)


### Bug Fixes

* Use IPv6 CIDR block destination on route when IPv6 support is enabled ([#102](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/102)) ([f70ec98](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/f70ec98e82ebab67b03450ccb4b2717ae8a42578))

## [2.12.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.11.0...v2.12.0) (2023-12-11)


### Features

* Allow creating VPC routes for already existing or shared TGW ([#114](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/114)) ([20c4dc4](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/20c4dc4f698bc9edc7b7936ee7befb50043ded8a))

## [2.11.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.10.0...v2.11.0) (2023-12-11)


### Features

* Make TGW routing creation optional ([#119](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/119)) ([1661dfa](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/1661dfa3f538c8d5b4f612a7c0982e4afd20daca))

## [2.10.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.9.0...v2.10.0) (2023-04-26)


### Features

* Fixed typo in mutlicast to multicast, also in the variable name ([#108](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/108)) ([baaa7f4](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/baaa7f44c458d29b95d372e3faae7f89a148da0c))

## [2.9.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.8.2...v2.9.0) (2023-02-27)


### Features

* Added tags per VPC attachment ([#103](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/103)) ([e4d6df2](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/e4d6df2aa4bab0d840bbab71276cca3bc69f9113))

### [2.8.2](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.8.1...v2.8.2) (2023-01-24)


### Bug Fixes

* Use a version for  to avoid GitHub API rate limiting on CI workflows ([#96](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/96)) ([de6e0cf](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/de6e0cf41b7ee1b84e506f77415257f01f51065d))

### [2.8.1](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.8.0...v2.8.1) (2022-10-27)


### Bug Fixes

* Update CI configuration files to use latest version ([#88](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/88)) ([12ccdcc](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/12ccdcc0a209973e391e05079f3e1f04c0a78ff7))

## [2.8.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.7.0...v2.8.0) (2022-05-09)


### Features

* Added TGW multicast support ([#73](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/73)) ([a4d569b](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/a4d569b7f03443921d9dff7ce54f8acc06aed7fa))

## [2.7.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.6.0...v2.7.0) (2022-03-26)


### Features

* Add support for transit gateway CIDR blocks ([#69](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/69)) ([131ed50](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/131ed5006713aec86a20147796ce6489f6daadc6))

## [2.6.0](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.5.1...v2.6.0) (2022-03-26)


### Features

* Update Terraform minimum supported version to `v0.13.1` ([#68](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/68)) ([4e8f9c9](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/4e8f9c95d429d8f623db563388fe759707e38379))

### [2.5.1](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.5.0...v2.5.1) (2022-01-10)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#63](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/63)) ([558f5ff](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/commit/558f5ff261d9e5b25304c3f38ae0242850c92b2b))

<a name="v2.5.0"></a>
## [v2.5.0] - 2021-07-07

- fix: add tags if the default route table association is enabled ([#52](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/52))


<a name="v2.4.0"></a>
## [v2.4.0] - 2021-05-24

- feat: Optionally update VPC Route Tables for attached VPCs ([#35](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/35))


<a name="v2.3.0"></a>
## [v2.3.0] - 2021-05-19

- feat: default tgw route table tags ([#49](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/49))


<a name="v2.2.0"></a>
## [v2.2.0] - 2021-05-19

- feat: adding appliance_mode_support to vpc attachments ([#48](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/48))


<a name="v2.1.0"></a>
## [v2.1.0] - 2021-05-05

- fix: Update map function to work in Terraform 0.15 ([#44](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/44))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#42](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/42))


<a name="v2.0.0"></a>
## [v2.0.0] - 2021-04-27

- feat: Shorten outputs (removing this_) ([#41](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/41))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#40](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/40))
- chore: align ci-cd static checks to use individual minimum Terraform versions ([#38](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/38))
- fix: bump min supported version due to types unsupported on current ([#37](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/37))
- chore: add ci-cd workflow for pre-commit checks ([#36](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/36))


<a name="v1.4.0"></a>
## [v1.4.0] - 2020-11-24

- fix: Updated supported Terraform versions ([#30](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/30))
- docs: typos on example readme.mds ([#21](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/21))


<a name="v1.3.0"></a>
## [v1.3.0] - 2020-08-18

- fix: Added support for multi-account deployments ([#20](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/20))


<a name="v1.2.0"></a>
## [v1.2.0] - 2020-08-17

- chore: Minor updates in docs
- fix: fix variable in aws_ec2_transit_gateway_route_table_propagation ([#13](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/issues/13))


<a name="v1.1.0"></a>
## [v1.1.0] - 2020-01-16

- Updated notes in example


<a name="v1.0.0"></a>
## [v1.0.0] - 2020-01-15

- Added code for the module


<a name="v0.0.1"></a>
## v0.0.1 - 2020-01-15

- Initial commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.5.0...HEAD
[v2.5.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.4.0...v2.5.0
[v2.4.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v1.4.0...v2.0.0
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/compare/v0.0.1...v1.0.0
