aws_route
=========

Summary
-------
This example introduces ``aws_route`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``destination_ipv6_cidr_block``
* ``egress_only_gateway_id``
* ``nat_gateway_id``
* ``network_interface_id``
* ``transit_gateway_id``
* ``vpc_peering_connection_id``

Notes
~~~~~

For ``gateway_id`` attribute you can supply ``instance_id``, ``gateway_id``.

Example
-------
.. literalinclude:: main.tf
