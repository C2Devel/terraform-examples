aws_route_table
===============

Summary
-------
This example introduces ``aws_route_table`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``propagating_vgws``

NOTES
~~~~~

'ipv6_cidr_block', 'egress_only_gateway_id', 'gateway_id',
'nat_gateway_id', 'transit_gateway_id', 'vpc_peering_connection_id'
attributes are not supported for inline route object.

Example
-------
.. literalinclude:: main.tf
