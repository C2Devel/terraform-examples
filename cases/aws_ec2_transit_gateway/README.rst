aws_ec2_transit_gateway
=======================

Summary
-------
This example introduces ``aws_ec2_transit_gateway`` resource.

Two VPCs with non-overlapping CIDRs are attached to a single transit gateway
with ``aws_ec2_transit_gateway_vpc_attachment`` resource. A route to the
opposite VPC CIDR is added to the main route table of each VPC with
``aws_route`` resource and its ``transit_gateway_id`` attribute, so instances
in both VPCs can reach each other through the transit gateway.

VPCs and subnets are declared in the ``first_infra.tf`` and ``second_infra.tf``
files.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``amazon_side_asn``
* ``arn``
* ``auto_accept_shared_attachments``
* ``dns_support``
* ``multicast_support``
* ``transit_gateway_cidr_blocks``
* ``vpn_ecmp_support``

Notes
~~~~~

``shared_owners`` attribute is an extension of the resource: it holds the list
of project IDs (``project@customer``) that are granted access to the transit
gateway. Do not manage transit gateway sharing in more than one place: use
either ``shared_owners`` or ``aws_ec2_transit_gateway_project_access``
resource, otherwise the two will conflict.

``default_route_table_association`` and ``default_route_table_propagation``
attributes accept ``enable`` and ``disable`` values, both default to
``enable``.

Example
-------
.. literalinclude:: main.tf
