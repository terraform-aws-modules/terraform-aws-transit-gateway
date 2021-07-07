# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



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
