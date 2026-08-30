# Multi Region Transit Gateway

A transit gateway in each of two Regions, peered together, so spokes in one Region can
reach spokes in the other.

This is the architecture the peering attachment exists for. Without it the module can
build a hub in a single Region and nothing beyond it.

## Architecture

```
   eu-west-1                             eu-central-1
   ┌──────────────────────┐              ┌──────────────────────┐
   │  VPC 10.10.0.0/16    │              │  VPC 10.20.0.0/16    │
   │        │             │              │        │             │
   │   TGW attachment     │              │   TGW attachment     │
   │        │             │              │        │             │
   │   transit gateway ───┼── peering ───┼─── transit gateway   │
   └──────────────────────┘              └──────────────────────┘
        requester                              accepter
```

## Why acceptance is a separate module instance

A peering attachment is created by one side and has to be accepted by the other, and the
accepter needs the far Region's credentials. It also cannot run until the attachment
exists. Putting both in one module instance would be a dependency cycle, so the accepter
is a third instance with `create_tgw = false`.

That instance also sets `share_tgw = false`. The module's RAM share accepter is gated on
`!create_tgw && share_tgw`, and `share_tgw` defaults to `true`, so an instance that exists
only to accept a peering attachment would otherwise try to accept a resource share that
was never offered.

## Routing

Peering attachments carry **static routes only**. Setting `dynamic_routing = "enable"` is
rejected by the API with `You cannot create a dynamic peering attachment`. Routes across
the peering are added to the transit gateway route tables explicitly.

## Usage

```bash
$ terraform init && terraform apply
```

Creates transit gateways and attachments in two Regions, which cost money. Run
`terraform destroy` when finished.
