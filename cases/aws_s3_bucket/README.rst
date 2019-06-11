aws_s3_bucket
=============

Summary
-------
This example introduces ``aws_s3_bucket`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``noncurrent_version_transition``
* ``replication``
* ``logging``
* ``acceleration_status``
* ``region``
* ``request_payer``
* ``replication_configuration``
* ``object_lock``
* ``server_side_encryption_configuration``
* ``attributes are not supported``

Notes
~~~~~

Supported values for ``acl`` attribute are:

* ``private``
* ``public-read``
* ``public-read-write``
* ``authenticated-read``

Example
-------
.. literalinclude:: main.tf

